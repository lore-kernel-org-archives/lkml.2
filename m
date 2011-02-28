Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1B1X3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:29:47 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:39269 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753716Ab1B1X3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:29:46 -0500
Message-ID: <4D6C2FF6.9080507@lougher.demon.co.uk>
Date: Mon, 28 Feb 2011 23:29:58 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] Squashfs:  add compressor specific options support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Latest round of Squashfs patches aimed at the next merge window.
These patches mainly add support for compressor specific options,
but there's the usual couple of trivial patches.

Phillip Lougher (6):
       Squashfs: extend decompressor framework to handle compression options
       Squashfs: add compression options support to xz decompressor
       Squashfs: Update Kconfig help text to include xz compression
       Squashfs: Update documentation to include compression options
       Squashfs: xz_wrapper doesn't need to include squashfs_fs_i.h anymore
       Squashfs: wrap squashfs_mount() definition

  Documentation/filesystems/squashfs.txt |   28 +++++++++++-----
  fs/squashfs/Kconfig                    |   12 +++---
  fs/squashfs/decompressor.c             |   34 ++++++++++++++++++++
  fs/squashfs/decompressor.h             |    7 +---
  fs/squashfs/lzo_wrapper.c              |    4 +-
  fs/squashfs/squashfs.h                 |    1 +
  fs/squashfs/squashfs_fs.h              |    4 ++
  fs/squashfs/super.c                    |   15 +++++---
  fs/squashfs/xz_wrapper.c               |   53 ++++++++++++++++++++++++++------
  fs/squashfs/zlib_wrapper.c             |    4 +-
  10 files changed, 121 insertions(+), 41 deletions(-)
