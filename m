Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1GNIIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:08:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:58810 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1GNIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:08:36 -0400
Date: Thu, 14 Jul 2011 10:08:30 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Yuan-Hsin Chen <yhchen@faraday-tech.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 4/5] fusb300_udc: Add missing breaks in switch/case
Message-ID: <20110714080830.GA7149@linutronix.de>
References: <cover.1310289795.git.joe@perches.com>
 <08f6dd600dbf588e87734b3a6b33d897cd253fe3.1310289795.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <08f6dd600dbf588e87734b3a6b33d897cd253fe3.1310289795.git.joe@perches.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joe Perches | 2011-07-10 02:28:27 [-0700]:

>Signed-off-by: Joe Perches <joe@perches.com>
>---
> drivers/usb/gadget/fusb300_udc.c |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
>index 06353e7..453bc0f 100644
>--- a/drivers/usb/gadget/fusb300_udc.c
>+++ b/drivers/usb/gadget/fusb300_udc.c
>@@ -688,10 +688,13 @@ static void fusb300_cmp_dbg_fifo(struct fusb300_ep *ep,
> 	switch (length % 4) {
> 	case 1:
> 		golden_value = *tmp;
>+		break;
> 	case 2:
> 		golden_value = *tmp | *(tmp + 1) << 8;
>+		break;
> 	case 3:
> 		golden_value = *tmp | *(tmp + 1) << 8 | *(tmp + 2) << 16;
>+		break;
> 	default:
> 		break;
> 

That is in an #if 0 block. Maybe we should remove the #if 0? Yuan-Hsin?

Sebastian
