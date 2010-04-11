Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855Ab0DKEOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 00:14:10 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:33430 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab0DKEOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 00:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=mLp
	H3XwgR4yR0+bOL8UWdo/JAl2mXF+bGAviOefBW3pvIYOFNGw9vxe5Aw8+PEoxzia
	s8tLftA9XyE9q8CwtJsEWrR302EedN3uiAmbpzKqjPyZSyMYpyU4dNXh7OA7CEsa
	YbA6NHRYCZQmDhMjShI3JjD0RTYmj2ChPJ6J5roc=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.1.rc1
From: Junio C Hamano <gitster@pobox.com>
Date: Sat, 10 Apr 2010 21:13:56 -0700
Message-ID: <7vmxxar5h7.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: A8AE1FA2-4520-11DF-92B7-D033EE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.1.rc1 is available at the usual places
for testing:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.1.rc1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.1.rc1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.1.rc1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  testing/git-*-1.7.1.rc1-1.fc11.$arch.rpm	(RPM)

Please test 'master', report & fix regressions.  Hopefully we can do
another rc during the next week and release the final one next weekend.

----------------------------------------------------------------

Changes since v1.7.1-rc0 are as follows:

Brandon Casey (1):
      notes.h: declare bit field as unsigned to silence compiler complaints

Jeff King (4):
      fix const-correctness of write_sha1_file
      fix textconv leak in emit_rewrite_diff
      fix typos and grammar in 1.7.1 draft release notes
      docs: clarify "branch -l"

Jens Lehmann (2):
      Let check_preimage() use memset() to initialize "struct checkout"
      Teach diff --submodule and status to handle .git files in submodules

Jonathan Nieder (1):
      Teach mailinfo %< as an alternative scissors mark

Junio C Hamano (2):
      diff.c: work around pointer constness warnings
      Git 1.7.1-rc1

Mark Rada (6):
      Gitweb: add ignore and clean rules for minified files
      Gitweb: add support for minifying gitweb.css
      Gitweb: add autoconfigure support for minifiers
      instaweb: add minification awareness
      gitweb: add documentation to INSTALL regarding gitweb.js
      gitweb: update INSTALL to use shorter make target

Michael J Gruber (2):
      t3301-notes: Test the creation of reflog entries
      refs.c: Write reflogs for notes just like for branch heads

Tay Ray Chuan (2):
      branch: say "Reset to" in reflog entries for 'git branch -f' operations
      fetch/push: fix usage strings

