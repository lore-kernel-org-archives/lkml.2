Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1KHC4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 21:56:34 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:42986 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1KHC4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 21:56:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=o9eef+9SxzwUMosmr58
	PxvLEiGYtmqU9BIEMdqVOut0gBpWV5t3jJe3XrpueZrPZEXTUTxBWrTlTGGoqE2q
	Xj0lSxxeRJSD224fxHR0v9xEZWEDgqbuLUxuFC61tRj17yyVyoj1qhziAI50cK4m
	hNJ6j2pt/Lo5UuM1E3FcftKc=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.8.rc1
Date: Mon, 07 Nov 2011 18:56:28 -0800
Message-ID: <7vwrbbz5ib.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 41EFB69E-09B5-11E1-B48B-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.8.rc1 is available for testing. Since rc0, we
killed all known regressions. Because there won't be any more new feature
merged until the 1.7.8 final, it is a good time for the coolest kids on
the block to start using the upcoming release before others do.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

f35e5c4410b21710434cb591f4c89843e75bb793  git-1.7.8.rc1.tar.gz
72e27cd397f5ae7b3c9d8bb030a76d7c99cdbb50  git-htmldocs-1.7.8.rc1.tar.gz
95429858e879df3f9425cf1279e03cdec7832379  git-manpages-1.7.8.rc1.tar.gz

Also the following public repositories all have a copy of the v1.7.8.rc1
tag and the master branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

----------------------------------------------------------------

Changes since v1.7.8-rc0 are as follows:

Dan McGee (4):
      pack-objects: mark add_to_write_order() as inline
      pack-objects: use unsigned int for counter and offset values
      pack-objects: rewrite add_descendants_to_write_order() iteratively
      pack-objects: don't traverse objects unnecessarily

Erik Faye-Lund (4):
      mingw: move poll out of sys-folder
      compat/win32/poll.c: upgrade from upstream
      upload-archive: use start_command instead of fork
      mingw: poll.h is no longer in sys/

Johannes Sixt (1):
      name-hash.c: always initialize dir_next pointer

Junio C Hamano (5):
      (squash) test for previous
      Git 1.7.7.2
      Update draft release notes to 1.7.8
      receive-pack: do not expect object 0{40} to exist
      Git 1.7.8-rc1

Nguyễn Thái Ngọc Duy (2):
      pretty.c: free get_header() return value
      pretty.c: use original commit message if reencoding fails

Pat Thoyts (1):
      t7511: avoid use of reserved filename on Windows.

Pete Wyckoff (1):
      git-p4: ignore apple filetype

Sebastian Schuberth (2):
      blame.c: Properly initialize strbuf after calling, textconv_object()
      blame.c: Properly initialize strbuf after calling textconv_object(), again

Stefan Naewe (2):
      t3200: add test case for 'branch -m'
      http: don't always prompt for password

Tay Ray Chuan (1):
      branch -m: handle no arg properly

Ted Percival (1):
      svn: Quote repository root in regex match

Ævar Arnfjörð Bjarmason (2):
      t/t6030-bisect-porcelain.sh: use test_i18ngrep
      t/t7508-status.sh: use test_i18ncmp

