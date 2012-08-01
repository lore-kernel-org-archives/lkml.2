Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab2HAEyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 00:54:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64111 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2HAEym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 00:54:42 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, linux-kernel@vger.kernel.org,
        Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 0/5] Android: Small documentation changes and a bug fix
Date: Wed,  1 Aug 2012 14:54:15 +1000
Message-Id: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This set of patches completes more documentation in android/logger.c, as well as fixing a bug there and a comment formatting issue in android/ashmem.c.

Sorry if kernel-doc was not supposed to be applied to driver files - If it isn't, I'll be sure to remember that for next time. :)

Cruz Julian Bishop (5):
  Fix comment/license formatting in android/ashmem.c
  Complete documentation of logger_entry in android/logger.h
  Finish documentation of two structs in android/logger.c
  Redocument some functions in android/logger.c
  Fixes a potential bug in android/logger.c

 drivers/staging/android/ashmem.c |   32 ++++-----
 drivers/staging/android/logger.c |  134 +++++++++++++++++++++++++-------------
 drivers/staging/android/logger.h |   24 +++++--
 3 files changed, 121 insertions(+), 69 deletions(-)

-- 
1.7.9.5

