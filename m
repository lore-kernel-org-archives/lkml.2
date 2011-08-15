Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1HORnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 13:43:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39780 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751302Ab1HORnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 13:43:14 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/s9nQTmsnspgQGUTBq8omLa81eKxIlepqJU+mT+7
	cBgI25FtQHddla
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] video/atmel_lcdfb: Fix build failure/typo for avr32 defconfig
Date: Mon, 15 Aug 2011 19:43:07 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39.3; KDE/4.4.5; x86_64; ; )
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <1313429190-29275-1-git-send-email-peterhuewe@gmx.de> <201108151931.27607.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108151931.27607.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108151943.08347.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 15 August 2011, 19:31:27 schrieb Laurent Pinchart:
> Thanks for the patch. I've already submitted the same patch
> (https://patchwork.kernel.org/patch/990792/) nearly a month ago to the
> linux- fbdev mailing list. Paul, can you please pick it up ?

Ah okay, didn't see it. I usually look on the lkml if the problem was already 
fixed lately but somehow missed your patch.

Since you've done exactly what my patch did you get my 
Reviewed-by: Peter Huewe <peterhuewe@gmx.de>

Thanks,
Peter


