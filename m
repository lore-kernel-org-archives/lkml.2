Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0G1Rls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:41:48 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:37907 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0G1Rlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=sLRkR0lpRopjbyPpQ3p
	Za5BU6lzofa1ZRKPpdE0OHuIwOoBEUhNpXgbxF9C49yp4U9gOapFNu7fvMRjV58w
	b07jLFjuuytqB7E78K8L2dMpj5GIZlTYPAWW29FV64mx5EJHlfvsb5oIYjqNXc94
	ZMLezAUUVT+F/WTCyLLZ+OgI=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.2.1 (also 1.7.1.2 and 1.7.0.7)
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 28 Jul 2010 10:41:33 -0700
Message-ID: <7vd3u74i7m.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 5FDD7184-9A6F-11DF-9D8C-9056EE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.2.1 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.2.1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.2.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.2.1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.2.1-1.fc11.$arch.rpm	(RPM)

Two fixes to segfaulting bugs in this release have also been merged to
produce maintenance releases for older codebase, 1.7.0.7 and 1.7.1.2,
primarily for people who do not want to have .2 in the third digit of the
version of git they use for whatever reason ;-)


Git v1.7.2.1 Release Notes
==========================

Fixes since v1.7.2
------------------

 * "git instaweb" wasn't useful when your Apache was installed under a
   name other than apache2 (e.g. "httpd").

 * Similarly, "git web--browse" (invoked by "git help -w") learned that
   chrome browser is sometimes called google-chrome.

 * An overlong line after ".gitdir: " in a git file caused out of bounds
   access to an array on the stack.

 * "git config --path conf.var" to attempt to expand a variable conf.var
   that uses "~/" short-hand segfaulted when $HOME environment variable
   was not set.

 * Documentation on Cygwin failed to build.

 * The error message from "git pull blarg" when 'blarg' is an unknown
   remote name has been improved.

And other minor fixes and documentation updates.

----------------------------------------------------------------

Changes since v1.7.2 are as follows:

Brandon Casey (1):
      git-rebase--interactive.sh: use printf instead of echo to print commit message

Dan McGee (3):
      git-instaweb: Fix custom apache log placement
      git-instaweb: Fix Apache environment variable passing
      git-instaweb: Don't assume Apache executable is named apache2

Greg Brockman (1):
      Check size of path buffer before writing into it

Johannes Sixt (1):
      t3700-add: fix dependence on stdout and stderr buffering

Jon Seymour (1):
      INSTALL: configure /etc/xml/catalog to build docs on Cygwin

Jonathan Nieder (1):
      config --get --path: check for unset $HOME

Junio C Hamano (3):
      Git 1.7.0.7
      Git 1.7.1.2
      Git 1.7.2.1

Matthieu Moy (1):
      Clarify help message when no remote is specified in fetch/pull.

Nathan W. Panike (1):
      Add a google-chrome option for web--browse

Nguyễn Thái Ngọc Duy (1):
      git-read-tree.txt: acknowledge the directory matching bug in sparse checkout

Stephen Boyd (2):
      request-pull.txt: Document -p option
      commit: remove full stop from usage help for -u

Thomas Rast (5):
      Cast execl*() NULL sentinels to (char *)
      Document receive.denyDeleteCurrent
      Documentation/git-push: Explain status output in more detail
      Fix 'git' wrapper usage string
      Makefile: add check-docs exception for gitrevisions

