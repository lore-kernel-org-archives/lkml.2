Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1AFVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:09:58 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:36416 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304Ab1AFVJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:09:57 -0500
Message-ID: <4D262F9F.4090709@lougher.demon.co.uk>
Date: Thu, 06 Jan 2011 21:09:51 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux Kernel Development <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/5] Squashfs: various minor code improvements
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A couple of patches that tweak various pieces of code.

Phillip Lougher (5):
       Squashfs: remove unnecessary variable in zlib_wrapper
       Squashfs: add missing check in zlib_wrapper
       Squashfs: get rid of default n in Kconfig
       Squashfs: move squashfs_i() definition from squashfs.h
       Squashfs: simplify CONFIG_SQUASHFS_LZO handling

  fs/squashfs/Kconfig         |    3 ---
  fs/squashfs/block.c         |    1 -
  fs/squashfs/cache.c         |    1 -
  fs/squashfs/decompressor.c  |   13 +++++--------
  fs/squashfs/fragment.c      |    1 -
  fs/squashfs/id.c            |    1 -
  fs/squashfs/lzo_wrapper.c   |    1 -
  fs/squashfs/squashfs.h      |    8 --------
  fs/squashfs/squashfs_fs_i.h |    6 ++++++
  fs/squashfs/xattr_id.c      |    1 -
  fs/squashfs/zlib_wrapper.c  |   15 +++++++++------
  11 files changed, 20 insertions(+), 31 deletions(-)
