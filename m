Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab2HQLBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:01:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:49308 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812Ab2HQLBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:01:47 -0400
Message-ID: <502E2498.4090106@linutronix.de>
Date: Fri, 17 Aug 2012 13:01:44 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: balbi@ti.com
CC: Roland Stigge <stigge@antcom.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, aletes.xgr@gmail.com, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop interface
References: <1345131276-28982-1-git-send-email-stigge@antcom.de> <502D1A49.20603@linutronix.de> <502D1CC2.9020901@antcom.de> <502E0A7B.1040607@antcom.de> <20120817105103.GE4651@arwen.pp.htv.fi>
In-Reply-To: <20120817105103.GE4651@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 12:51 PM, Felipe Balbi wrote:
>> Sounds reasonable?
>
> no it doesn't. Please remove that static global. Sorry but one of the
> goals with udc_start/udc_stop was really to get rid of all those
> nonsensical static globals.

I wouldn't insist on it. If you look at pxa25x, " static struct
pxa25x_udc memory = {" they do the same thing. It is only a simple way
to onetime initialize variables.

Sebastian
