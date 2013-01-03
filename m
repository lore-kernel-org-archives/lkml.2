Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3ACKKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:10:50 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18090 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3ACKKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:10:47 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-ba-50e559259ee8
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 0/8] configfs checkpatch cleanup
Date: Thu, 03 Jan 2013 11:10:17 +0100
Message-id: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJMWRmVeSWpSXmKPExsVy+t/xy7qqkU8DDL5c1bC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZc3buYCtYIF4x710zewPjWaEuRg4OCQETiafb9boYOYFMMYkL
	99azgdhCAksZJRasL4CwNzBJ7FggBWKzCRhL7D3YwQhiiwgoSGzufcbaxcjFwSywnlFi4v0G
	sISwgIHEiglfmEBsFgFVifvnloAN5RVwlZh4tZcFYpm8xNP7fWwTGLkXMDKsYhRNLU0uKE5K
	zzXSK07MLS7NS9dLzs/dxAjx39cdjEuPWR1iFOBgVOLhZax/EiDEmlhWXJl7iFGCg1lJhPd6
	DlCINyWxsiq1KD++qDQntfgQIxMHp1QD41YHP6OgkK3rKvLjnxoxal58tc1CPPfLtrlGCy76
	3bzws1HlmIeKvpn/BquFX8Q3fLGf/3qBRHtWVPp+5gNe5++J2q/2N1343ZXF+uLiO5pzZpt+
	XLFYaOVc5kPzbxyon+LH+16t2jCvNFA4QEbwjvFv/RmbtgRvny10s6TjX+6+A/OuaG20LFRi
	Kc5INNRiLipOBAC8tlp3vQEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I noticed that configfs implementation has many style problems:

(checkpatch output edited for clarity)

total: 7 errors, 11 warnings, 260 lines checked
include/linux/configfs.h has style problems, please review.

total: 22 errors, 7 warnings, 160 lines checked
fs/configfs/configfs_internal.h has style problems, please review.

total: 53 errors, 20 warnings, 1756 lines checked
fs/configfs/dir.c has style problems, please review.

total: 45 errors, 16 warnings, 344 lines checked
fs/configfs/file.c has style problems, please review.

total: 19 errors, 7 warnings, 296 lines checked
fs/configfs/inode.c has style problems, please review.

total: 30 errors, 8 warnings, 216 lines checked
fs/configfs/item.c has style problems, please review.

total: 3 errors, 3 warnings, 183 lines checked
fs/configfs/mount.c has style problems, please review.

total: 14 errors, 3 warnings, 314 lines checked
fs/configfs/symlink.c has style problems, please review.

TOTAL: 193 errors, 75 warnings

I had some time at the end of the last year so I made this patch series.

After applying it:

total: 0 errors, 0 warnings, 269 lines checked
include/linux/configfs.h has no obvious style problems and is ready for submission.

total: 0 errors, 0 warnings, 166 lines checked
fs/configfs/configfs_internal.h has no obvious style problems and is ready for submission.

total: 0 errors, 0 warnings, 1766 lines checked
fs/configfs/dir.c has no obvious style problems and is ready for submission.

total: 0 errors, 0 warnings, 354 lines checked
fs/configfs/file.c has no obvious style problems and is ready for submission.

total: 0 errors, 0 warnings, 300 lines checked
fs/configfs/inode.c has no obvious style problems and is ready for submission.

total: 0 errors, 0 warnings, 214 lines checked
fs/configfs/item.c has no obvious style problems and is ready for submission.

total: 0 errors, 0 warnings, 183 lines checked
fs/configfs/mount.c has no obvious style problems and is ready for submission.

total: 0 errors, 0 warnings, 315 lines checked
fs/configfs/symlink.c has no obvious style problems and is ready for submission.

Andrzej Pietrasiewicz (8):
  fs/configfs: checkpatch cleanup
  fs/configfs: checkpatch cleanup
  fs/configfs: checkpatch cleanup
  fs/configfs: checkpatch cleanup
  fs/configfs: checkpatch cleanup
  fs/configfs: checkpatch cleanup
  fs/configfs: checkpatch cleanup
  fs/configfs: checkpatch cleanup

 fs/configfs/configfs_internal.h |   54 ++++----
 fs/configfs/dir.c               |  282 ++++++++++++++++++++-------------------
 fs/configfs/file.c              |  112 +++++++++-------
 fs/configfs/inode.c             |   46 ++++---
 fs/configfs/item.c              |   60 ++++-----
 fs/configfs/mount.c             |   12 +-
 fs/configfs/symlink.c           |   29 ++--
 include/linux/configfs.h        |   37 +++--
 8 files changed, 335 insertions(+), 297 deletions(-)

