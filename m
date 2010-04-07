Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab0DGPGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:06:07 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:58911 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642Ab0DGPGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=tsC
	LrT0gUNy4lQgoNk0l2+wXHqt//y1V06axjI/p9NUlLkLrUY1P2hgZc5mFE9dl4r5
	70eaGKHWFFb68HYGRDu3CWvlcmOIflYD3ZDs/DAm1CxRFIwMfKFAQOFVjYs//yoi
	5KvDHQEfzvMgAMPujgBb8/BJNsys77y8degWRDt8=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.1.rc0
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 07 Apr 2010 08:05:51 -0700
Message-ID: <7vmxxfe20g.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 119F0E4E-4257-11DF-B788-D033EE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.1.rc0 is available at the usual places
for testing:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.1.rc0.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.1.rc0.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.1.rc0.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  testing/git-*-1.7.1.rc0-1.fc11.$arch.rpm	(RPM)

----------------------------------------------------------------

Git v1.7.1 Release Notes (draft)
================================

Updates since v1.7.0
--------------------

 * Eric Raymond is the maintainer of updated CIAbot scripts, in contrib/.

 * Some commands (e.g. svn and http interfaces) that interactively ask
   password can be told to use an external program given via GIT_ASKPASS.

 * Conflict markers that lead the common ancestor in diff3-style output
   now has a label, which hopefully would help third-party tools that
   expect one.

 * Comes with an updated bash-completion script.

 * "git am" learned "--keep-cr" option to handle inputs that are
   mixture of changes to files with and without CRLF line endings.

 * "git cvsimport" learned -R option to leave revision mapping between
   CVS revisions and resulting git commits.

 * "git diff --submodule" notices and descries dirty submodules.

 * "git for-each-ref" learned %(symref), %(symref:short) and %(flag)
   tokens.

 * "git hash-object --stdin-paths" can take "--no-filters" option now.

 * "git init" can be told to look at init.templatedir configuration
   variable (obviously that has to come from either /etc/gitconfig or
   $HOME/.gitconfig).

 * "git grep" learned "--no-index" option, to search inside contents that
   are not managed by git.

 * "git grep" learned --color=auto/always/never.

 * "git grep" learned to paint filename and line-number in colors.

 * "git log -p --first-parent -m" shows one-parent diff for merge
   commits, instead of showing combined diff.

 * "git merge-file" learned to use custom conflict marker size and also use
   the "union merge" behaviour.

 * "git notes" command has been rewritten in C and learned quite a
   many commands and features to help you carry notes forward across
   rebases and amends.

 * "git request-pull" identifies the commit the request is relative to in
   a more readable way.

 * "git reset" learned "--keep" option that lets you discard commits
   near the tip while preserving your local changes in a way similar
   to how "git checkout branch" does.

 * "git status" notices and descries dirty submodules.

 * "git svn" should work better when interacting with repositories
   with CRLF line endings.

 * "git imap-send" learned to support CRAM-MD5 authentication.

Fixes since v1.7.0
------------------

All of the fixes in v1.7.0.X maintenance series are included in this
release, unless otherwise noted.

 * "git add frotz/nitfol" did not complain when the entire frotz/ directory
   was ignored.

 * "git rev-list --pretty=oneline" didn't terminate a record with LF for
   commits without any message.

 * "git rev-list --abbrev-commit" defaulted to 40-byte abbreviations, unlike
   newer tools in the git toolset.
