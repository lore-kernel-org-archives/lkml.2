Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab1KPP5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:57:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54650 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab1KPP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:57:20 -0500
From: Thomas Weber <weber@corscience.de>
To: tony@atomide.com
Cc: Thomas Weber <weber@corscience.de>,
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-omap@vger.kernel.org (open list:OMAP SUPPORT),
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH Resend] ARM: OMAP2+: Remove empty io.h
Date: Wed, 16 Nov 2011 16:56:52 +0100
Message-Id: <1321459012-15418-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.8.rc1
X-Provags-ID: V02:K0:nLguPj5h9O7hZWn9SosKLVhdbT3uTaMg7diAsGyiYOA
 S1kprI++TERn5cpdpDGGxOhlJGCsuwjHUHIcqwx1Ccs9O0KbNJ
 kaq/DoiadY2hAnEHFNDfW96x3QTHeBXA/+vWjZii02bHmqj6S2
 HSg9DKuu0uOoeq9ApUulAzeQQN3MnX8Aadp+7OUYWAEN/Ebzvf
 iRph4OfBYeMKwSXIV2ASNOxU8u6MI0tKPNKXCnnSHPN5Nv3Tzo
 ZDgOrYo7K+lGdp4g4puQ/13DlwHHh3FoS1sXb240A9WqKmcvnO
 vjQUwb9Yf1eutRfW4oMyxgkotU52KZwjPijX9Zo3HEQjzd58Df
 2GLEkmBBecROU8KfvOh/xdlP0HmaESo5agmoOrN6SXm+pnhg35
 tBLeqLVKfuxvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file arch/arm/mach-omap2/io.h is empty, so we can remove it.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/io.h

diff --git a/arch/arm/mach-omap2/io.h b/arch/arm/mach-omap2/io.h
deleted file mode 100644
index e69de29..0000000
-- 
1.7.8.rc1

