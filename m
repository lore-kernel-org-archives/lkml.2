Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1ANGdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 01:33:37 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:34692 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1ANGdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 01:33:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=BCb
	XyzNjKAvxkUlV9EdnipK9d0dlDNdnaNBByn+w6rjkrgneMsKZJ0TepTAHiNYqtRn
	8pOQe41k6nb+GcWOG4a6qoIrbau/YBM3wJkodUw/vKzgFbKORZXBVhjk+cNoEiil
	Ra2Zw6eLS/MrDi1ybHYIuyz55kXtx4lLiaQxwUC0=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.4-rc2
From: Junio C Hamano <gitster@pobox.com>
Date: Thu, 13 Jan 2011 22:33:21 -0800
Message-ID: <7voc7kngem.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 4BABB50E-1FA8-11E0-B579-94B21C7297B3-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.4-rc2 is available at the usual places
for testing:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.4.rc2.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.4.rc2.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.4.rc2.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  testing/git-*-1.7.4.rc2-1.fc13.$arch.rpm	(RPM)

Hopefully we can declare victory soon and cut the final mid-next week.

----------------------------------------------------------------
Changes since v1.7.4-rc1 include nothing spectacular.

Anders Kaseorg (1):
      Mark gitk script executable

Brandon Casey (3):
      trace.c: ensure NULL is not passed to printf
      t0001,t1510,t3301: use sane_unset which always returns with status 0
      t3032: limit sed branch labels to 8 characters

Jeff King (1):
      docs: explain diff.*.binary option

Jonathan Nieder (3):
      diff: funcname and word patterns for perl
      gitweb: make logo optional
      t9010: svnadmin can fail even if available

Junio C Hamano (2):
      userdiff/perl: catch BEGIN/END/... and POD as headers
      Git 1.7.4-rc2

Matthieu Moy (1):
      commit: suggest --amend --reset-author to fix commiter identity

Michael J Gruber (1):
      RelNotes/1.7.4: minor fixes

Ramsay Allan Jones (7):
      lib-git-svn.sh: Move web-server handling code into separate function
      t9157-*.sh: Add an svn version check
      t6038-*.sh: Pass the -b (--binary) option to sed on cygwin
      t3032-*.sh: Pass the -b (--binary) option to sed on cygwin
      t3032-*.sh: Do not strip CR from line-endings while grepping on MinGW
      t4135-*.sh: Skip the "backslash" tests on cygwin
      t9157-*.sh: Make the svn version check more precise

StephenB (1):
      git svn: fix the final example in man page

Sylvain Rabot (2):
      gitweb: add extensions to highlight feature map
      gitweb: remove unnecessary test when closing file descriptor

Thomas Rast (4):
      Documentation/git-archive: spell --worktree-attributes correctly
      Documentation/githooks: post-rewrite-copy-notes never existed
      submodule: fix relative url parsing for scp-style origin
      t0000: quote TAP snippets in test code

