Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab2HLJpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 05:45:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab2HLJpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 05:45:03 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 0/7] Fat checkstyle patch set (1)
Date: Sun, 12 Aug 2012 19:44:40 +1000
Message-Id: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi (and to the mailing list, again).

This is a patch series that fixes checkpatch issues in fs/fat.

I didn't get to do all of the files, but I'll be sure to come back for
them later :)

Please let me know if I did something wrong - I'll be sure to take it on
for my next patches.

Thanks in advance
~Cruz

Cruz Julian Bishop (7):
  fs/fat: Fix a checkpatch issue in namei_msdos.c
  fs/fat: Fix some checkpatch issues in fat.h
  fs/fat: Changed indentation of some comments in fat.h
  fs/fat: Fix two checkstyle issues in cache.c
  fs/fat: Fixes some small checkpatch issues is dir.c
  fs/fat: Fix all other checkstyle issues in dir.c
  fs/fat: Fix checkpatch issues in fatent.c

 fs/fat/cache.c       |   10 ++++---
 fs/fat/dir.c         |   31 ++++++++++----------
 fs/fat/fat.h         |   78 +++++++++++++++++++++++++-------------------------
 fs/fat/fatent.c      |   10 ++++---
 fs/fat/namei_msdos.c |    2 +-
 5 files changed, 67 insertions(+), 64 deletions(-)

-- 
1.7.9.5

