Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab1CDERD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 23:17:03 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39231 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465Ab1CDERB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 23:17:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RK5Uk4fDRK21if3zVGV5SST/9dgqF1iMx2JjukMif5u9iKAn0WlVJWAchCpSkEvBSM
         lk4SBILaUUcZpX5sdTKXoq0BeQaj2kH2Xr8iHNG6cXZ0/qURWa/V3dipEyfEQ+1MUbrA
         /Ozk6tFk0bAFc84RIL8TXrMTRsura4RNSkVdo=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, oakad@yahoo.com
Subject: [PATH 0/4] Memstick patches for 2.6.39
Date: Fri,  4 Mar 2011 06:16:49 +0200
Message-Id: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a repost of my patches for 2.6.39 inclusion, which I hope not to
miss this time.

I addressed the comments on the scatterlist issues.

Andrew, please note that my richoh memstick driver is standalone, unchanged from previos versions
has many users which use the version I posted at ubuntu's Launchpad and happy with it.
Please include it regardless of other patches.

The other half of my work is support for legacy memorysticks which consists of 2 patches,
first that adds few functions to scatterlist.c, and the other patch that adds the driver.
Driver is also stable and tested.

Best regards,
	Maxim Levitsky

