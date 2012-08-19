Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2HSMeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 08:34:00 -0400
Received: from antcom.de ([188.40.178.216]:43736 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2HSMd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 08:33:59 -0400
Message-ID: <5030DD33.7040804@antcom.de>
Date: Sun, 19 Aug 2012 14:33:55 +0200
From: Roland Stigge <stigge@antcom.de>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop interface
References: <1345131276-28982-1-git-send-email-stigge@antcom.de> <502D1A49.20603@linutronix.de> <502D1CC2.9020901@antcom.de> <502E0A7B.1040607@antcom.de> <502E11F7.4080300@linutronix.de>
In-Reply-To: <502E11F7.4080300@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/08/12 11:42, Sebastian Andrzej Siewior wrote:
> Some minor things:
> - please use to_udc() in start then
> - would it make sense to use platform_get_drvdata() in
>   lpc32xx_udc_shutdown() ?
> - could you please remove struct usb_endpoint_descriptor from struct
>   lpc32xx_ep? It has been removed a while back from other drivers.

I merged these changes into the patch set, and will repost it tomorrow
after I can test it more thoroughly.

Thanks,

Roland
