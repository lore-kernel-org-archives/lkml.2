Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab2GBLvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:51:17 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:34274 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750909Ab2GBLvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:51:15 -0400
Message-ID: <4FF18B2C.8080102@ti.com>
Date: Mon, 02 Jul 2012 17:21:08 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: ben-linux@fluff.org, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de
Subject: Re: [PATCH v2 05/17] i2c: omap: split out [XR]DR and [XR]RDY
References: <1339691067-919-1-git-send-email-balbi@ti.com> <1339691067-919-6-git-send-email-balbi@ti.com> <4FE991DA.5070301@ti.com> <20120702113314.GA2730@arwen.pp.htv.fi>
In-Reply-To: <20120702113314.GA2730@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2012 05:03 PM, Felipe Balbi wrote:
>>> +				num_bytes = dev->fifo_size;
>> > In case of a draining interrupt. The byte count may not be the fifo size.
>> > Do you agree?
> hmm... indeed, that should be dev->buf_len... can you fix that up or
> want me to resend ?
Nope I can fix that up.
Thanks,

