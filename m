Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1LLRYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:24:38 -0500
Received: from mail209.messagelabs.com ([216.82.255.3]:47470 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1LLRYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:24:35 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1323710078!24542873!329
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.4.3; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
CC: "'Richard Purdie'" <rpurdie@rpsys.net>
Date: Mon, 12 Dec 2011 11:24:14 -0600
Subject: RE: [PATCH] backlight: ep93xx_bl: remove duplicated header include
Thread-Topic: [PATCH] backlight: ep93xx_bl: remove duplicated header include
Thread-Index: Acy4osnwbgdZQ6pVT2KpCyJbhfF1fAAT6E4g
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3E9976C46@AUSP01VMBX24.collaborationhost.net>
References: <001201ccb8a2$ca235e30$5e6a1a90$%han@samsung.com>
In-Reply-To: <001201ccb8a2$ca235e30$5e6a1a90$%han@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 12, 2011 12:51 AM, Jingoo Han wrote:
>
> This patch removes duplicated module header for EP93xx backlight
> driver.
> drivers/video/backlight/ep93xx_bl.c: module.h is included more
> than once.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Hmm.. Looks like there were two commits that add it...

commit 15b1a8f2b990c0c1dacfad0e5ccaf05c32c52147
Author: Axel Lin <axel.lin@gmail.com>
Date:   Thu Aug 25 15:59:14 2011 -0700

	drivers/video/backlight/ep93xx_bl.c: add missing include of linux/module.h

commit 355b200bacdb6017669cdc5bc9e7b1037aac42a2
Author: Paul Gortmaker <paul.gortmaker@windriver.com>
Date:   Sun Jul 3 16:17:28 2011 -0400

	video: Add module.h to drivers/video files who really use it.

It is needed, but there should only be one so...

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
