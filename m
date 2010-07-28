Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab0G1T7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:59:37 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:46275 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751797Ab0G1T7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:59:36 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Russell King <linux@arm.linux.org.uk>
Subject: cyber2000fb - 24bpp and 32bpp modes not working
Date: Wed, 28 Jul 2010 21:59:16 +0200
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007282159.19583.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
some more CyberPro 2000 testing shows that 24bpp and 32bpp modes don't work. 
8bpp and 16bpp modes work fine.

The mode appears to be set correctly (monitor OSD shows correct resolution and 
frequency) but console remains blank (even no cursor).

Xorg with fbdev in 24bpp mode displays mouse cursor, then gdm background and 
gdm login window and immediately segfaults. Xorg with fbdev in 32bpp mode 
works.

So the framebuffer works (24bpp crash might be Xorg bug) but maybe the console 
output is not written to the correct place?

-- 
Ondrej Zary
