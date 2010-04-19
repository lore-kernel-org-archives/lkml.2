Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab0DSTM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:12:57 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:58525 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0DSTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:12:56 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 15:12:56 EDT
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH 0/2] Fix some initramfs-related LZO decompression issues
Date: Mon, 19 Apr 2010 21:03:51 +0200
Message-Id: <1271703833-20058-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These 2 patches fix some issues with the current LZO decompressor code.
The first one (re-)enables the use of LZO-compressed external initramfs, which
has been broken for some time. The second one enables the use of in-kernel
initramfs compressed using LZO.
If that's possible, I'd like to get at least patch 1/2 in 2.6.34, since it
is an actual bug fix.

Albin Tonnerre (2):
  lib: fix initramfs usage for the LZO decompressor
  Add support for in-kernel initramfs compressed with LZO

 lib/decompress_unlzo.c        |   22 +++++++++++++++-------
 scripts/gen_initramfs_list.sh |    1 +
 usr/Makefile                  |    5 ++++-
 usr/initramfs_data.lzo.S      |   29 +++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+), 8 deletions(-)
 create mode 100644 usr/initramfs_data.lzo.S

