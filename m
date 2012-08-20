Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2HTHHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:07:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:60671 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab2HTHH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:07:26 -0400
Message-ID: <5031E228.80403@linutronix.de>
Date: Mon, 20 Aug 2012 09:07:20 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop interface
References: <1345131276-28982-1-git-send-email-stigge@antcom.de> <502D1A49.20603@linutronix.de> <502D1CC2.9020901@antcom.de> <502E0A7B.1040607@antcom.de> <502E11F7.4080300@linutronix.de> <5030DD33.7040804@antcom.de>
In-Reply-To: <5030DD33.7040804@antcom.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2012 02:33 PM, Roland Stigge wrote:
> On 17/08/12 11:42, Sebastian Andrzej Siewior wrote:
>> Some minor things:
>> - please use to_udc() in start then
>> - would it make sense to use platform_get_drvdata() in
>>    lpc32xx_udc_shutdown() ?
>> - could you please remove struct usb_endpoint_descriptor from struct
>>    lpc32xx_ep? It has been removed a while back from other drivers.
>
> I merged these changes into the patch set, and will repost it tomorrow
> after I can test it more thoroughly.

Thanks.
While you are playing with it, I saw that you handle vbus (->pull())
manually. This was the case in the "old" start/stop case but in the new
one, the udc-core is / should handle it.

>
> Thanks,
>
> Roland

Sebastian
