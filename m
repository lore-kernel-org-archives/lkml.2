Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0GVQ5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:57:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54636 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0GVQ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GkX8LM2/Iju4UgVlmqyBHkszinLr+Rgn67fBX/HWFtCQC3YHixg/IsWqLpTTnbzVnb
         K4KMx3PxDMhaV/W+27yT61VrcteqjBnHLNiCvsfRmK62VXYHIDdiYx6eWI/NlH367VRV
         +fEVgQ+kz6APlGUPy6BffM3OG0nkC0lkAtDRc=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 0/5] staging: clean up code a bit, use kernel native methods
Date: Thu, 22 Jul 2010 19:57:06 +0300
Message-Id: <cover.1279817399.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <20100722151545.GA6696@suse.de>
References: <20100722151545.GA6696@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko (5):
  staging: remove unused methods
  staging: panel: change own pieces of code by strtoul()
  staging: rtl8192su: don't use own isxdigit() method
  staging: wlags49_h2: remove custom hex_to_bin() method
  staging: wlan-ng: remove own bin2hex converter

 drivers/staging/otus/apdbg.c             |   22 -----------------
 drivers/staging/panel/panel.c            |   19 +++++---------
 drivers/staging/rtl8192su/r8192S_Efuse.c |   27 ++-------------------
 drivers/staging/wlags49_h2/wl_util.c     |   37 +-----------------------------
 drivers/staging/wlags49_h2/wl_util.h     |    2 -
 drivers/staging/wlan-ng/prism2sta.c      |    6 +---
 6 files changed, 13 insertions(+), 100 deletions(-)

