Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1K1Xh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:37:26 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:39337 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab1K1XhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=Mmsv192ssD9L3IvZNov
	9Z2+GepPBcnvjy7oaEoqavUDOBSTQB2aGkexV/YlZbf6jNvmN7sFTbwP+1iydYMQ
	WIJWR5D9ztExkIYWai4SwSIooES5UVy+/EQ35uqz0ItxlNScxFdqZNaS8IsGcqOB
	hVtUuZ6cydDN3qWJNztIJr38=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.8-rc4
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 28 Nov 2011 15:37:16 -0800
Message-ID: <7vvcq3u8cz.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: E8C79634-1A19-11E1-9B93-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.8-rc4 is available for testing. This hopefully
is the last rc before the final release (we had to make a last-minute UI
tweak to a new feature in multi-step "revert" command to avoid later
regrets). We already have interesting topics queued together with proposed
fixes for older non-regression bugs which would make the next cycle short,
sweet and fun.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

528b8099e980877eb7e2268be8afdf12efe13490  git-1.7.8.rc4.tar.gz
f775ddd3ee207816840ced38c28d1a400a823536  git-htmldocs-1.7.8.rc4.tar.gz
b35301ed60712f441a9c3af08446184faf624d51  git-manpages-1.7.8.rc4.tar.gz

Also the following public repositories all have a copy of the v1.7.8.rc4
tag and the master branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

----------------------------------------------------------------

Changes since v1.7.8-rc3 are as follows:

Johannes Sixt (1):
      Fix revert --abort on Windows

Jonathan Nieder (11):
      do not let git_path clobber errno when reporting errors
      notes merge: eliminate OUTPUT macro
      Makefile: add missing header file dependencies
      Makefile: add option to disable automatic dependency generation
      revert: rename --reset option to --quit
      revert: rearrange pick_revisions() for clarity
      revert: improve error message for cherry-pick during cherry-pick
      revert: write REVERT_HEAD pseudoref during conflicted revert
      revert: introduce --abort to cancel a failed cherry-pick
      revert: remove --reset compatibility option
      revert --abort: do not leave behind useless sequencer-old directory

Junio C Hamano (5):
      name-rev --all: do not even attempt to describe non-commit object
      Git 1.7.7.4
      Hopefully final update of release notes before 1.7.8 final
      Update 1.7.8 draft release notes in preparation for rc4
      Git 1.7.8-rc4

Marc-André Lureau (1):
      mailmap: xcalloc mailmap_info

Nguyễn Thái Ngọc Duy (1):
      revert: do not pass non-literal string as format to git_path()

Ramkumar Ramachandra (4):
      http: remove unused function hex()
      convert: don't mix enum with int
      sha1_file: don't mix enum with int
      git-compat-util: don't assume value for undefined variable

Ramsay Allan Jones (3):
      t5501-*.sh: Fix url passed to clone in setup test
      config.c: Fix a static buffer overwrite bug by avoiding mkpath()
      convert.c: Fix return type of git_path_check_eol()

Thomas Hochstein (1):
      documentation fix: git difftool uses diff tools, not merge tools.

Vincent van Ravesteijn (2):
      builtin-branch: Fix crash on invalid use of --force
      builtin-reset: Documentation update

