Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2HSMsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 08:48:37 -0400
Received: from antcom.de ([188.40.178.216]:53601 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab2HSMsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 08:48:36 -0400
Message-ID: <5030E0A1.8040401@antcom.de>
Date: Sun, 19 Aug 2012 14:48:33 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop interface
References: <1345131276-28982-1-git-send-email-stigge@antcom.de> <502D1A49.20603@linutronix.de> <502D1CC2.9020901@antcom.de> <502E0A7B.1040607@antcom.de> <20120817105103.GE4651@arwen.pp.htv.fi> <502E2498.4090106@linutronix.de> <20120817110256.GG4651@arwen.pp.htv.fi> <502E2BD4.5090803@antcom.de> <502E2D69.3040302@linutronix.de>
In-Reply-To: <502E2D69.3040302@linutronix.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/08/12 13:39, Sebastian Andrzej Siewior wrote:
>>                  .lep            = 0,
>>                  .eptype         = EP_CTL_TYPE,
>>          },
>>          .ep[1] = {
>>                  .ep = {
>>                          .name   = "ep1-int",
>>                          .ops    =&lpc32xx_ep_ops,
>>                  },
>>                  .udc            =&controller,
>>                  .maxpacket      = 64,
>>                  .hwep_num_base  = 2,
>>                  .hwep_num       = 0, /* 2 or 3, will be set later */
> 
> Why not now?

It's assigned dynamically at runtime, depending on RX or TX.

>>                  .lep            = 1,
>>                  .eptype         = EP_INT_TYPE,
> 
> Do you have any restrictions on these endpoints? I mean can you pick
> any endpoints for BULK/INT/ISO or have they been pre-defined by HW?

The latter, see LPC32xx user manual, 14.1.2.

Roland
