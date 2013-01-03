Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3ACLmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:42:53 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56715 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3ACLmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:42:52 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-9a-50e56eb94737
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH RESEND 0/8] configfs checkpatch cleanup
Date: Thu, 03 Jan 2013 12:42:33 +0100
Message-id: <1357213361-23620-1-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <"Message-id: <CAHdPZaNZQcS3YggV5rGkBGULp3BBBXXeeRn4BhTgNfLci0=AwA"@mail.gmail.com>
References: <"Message-id: <CAHdPZaNZQcS3YggV5rGkBGULp3BBBXXeeRn4BhTgNfLci0=AwA"@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJMWRmVeSWpSXmKPExsVy+t/xq7o7854GGDz8ZmxxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgy5vy9zVLwW7zid28newPjAuEuRk4OCQETiRP3m1ghbDGJC/fW
	s3UxcnEICSxllFj/4hI7hLOBSeLq7q2MIFVsAsYSew92gNkiAgoSm3ufsYIUMQusZ5SYeL8B
	LCEsYC7x60Q/mM0ioCqxrrUNzOYVcJXoO3aXDWKdvMTT+31gNqdAksTquy+ZQGwhgUSJc5MX
	M01g5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTI8TrX3YwLj5mdYhRgINRiYd3Rc2T
	ACHWxLLiytxDjBIczEoivNdzgEK8KYmVValF+fFFpTmpxYcYmTg4pRoY+btb8uemdov9K+jT
	lrcPePvfXiTkevXcJn/NqVI9Fxen2F99dfue7Xr7QFtWTk0ZEw/7JeJdtXfUrx3uu/jypmOK
	/NT4F8IRm1piZ0h/U7SP+MsWEvVvgcP3Y9Wy4rmXHLPMpHv3z7dYumenW+a87S8ztC4fbeB6
	evpOkOeBwOfljX3JjOpKLMUZiYZazEXFiQBGUZsM2AEAAA==
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
  fs/configfs: include/linux/configfs.h checkpatch cleanup
  fs/configfs: configfs_internal.h checkpatch cleanup
  fs/configfs: dir.c checkpatch cleanup
  fs/configfs: file.c checkpatch cleanup
  fs/configfs: inode.c checkpatch cleanup
  fs/configfs: item.c checkpatch cleanup
  fs/configfs: mount.c checkpatch cleanup
  fs/configfs: symlink.c checkpatch cleanup

 fs/configfs/configfs_internal.h |   54 ++++----
 fs/configfs/dir.c               |  282 ++++++++++++++++++++-------------------
 fs/configfs/file.c              |  112 +++++++++-------
 fs/configfs/inode.c             |   46 ++++---
 fs/configfs/item.c              |   60 ++++-----
 fs/configfs/mount.c             |   12 +-
 fs/configfs/symlink.c           |   29 ++--
 include/linux/configfs.h        |   37 +++--
 8 files changed, 335 insertions(+), 297 deletions(-)

