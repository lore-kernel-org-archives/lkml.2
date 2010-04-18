Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0DRSFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 14:05:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:48671 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752754Ab0DRSFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 14:05:42 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+0/4kwruS0I/piugbfmWb3758iRAbcor6MV4Cw6g
	g6GcC65/oyEm2a
Message-ID: <4BCB49EE.8050006@gmx.de>
Date: Sun, 18 Apr 2010 20:05:34 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 05/16] viafb: Determine type of 2D engine and store it
 in chip_info
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>	<1270746946-12467-6-git-send-email-corbet@lwn.net>	<4BBE9CFC.2020804@gmx.de>	<20100409141127.42e4e1fa@bike.lwn.net>	<4BBF8F48.2070902@gmx.de> <20100418113430.53760f99@bike.lwn.net>
In-Reply-To: <20100418113430.53760f99@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> [Getting back to the older stuff...]
> 
> On Fri, 09 Apr 2010 22:34:16 +0200
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
>>>> Just a minor nit:
>>>> Could we change the default so that if someone adds support for a new 
>>>> IGP (and misses this function) we default to either the newest or 
>>>> preferably to none? I've just seen too much poorly maintained code in 
>>>> this driver and defaulting to the oldest is hence a bad idea.
>>>> Otherwise it's fine.  
 >
> In the absence of that, the only course of action which makes sense is
> to simply fail the initialization if an unknown chip type shows up
> there.  That's easy, and I can do it.  But, given that this was a
> "minor nit," can we leave it as-is for now? 

Yes, if you  feel too uncomfortable with changing it and agree that the 
whole stuff should be made more maintainable later on I am okay with 
letting this in as is.

> There's a *lot* of things to clean up in this driver, I'd like to make it
 > better a step at a time rather than trying to do the whole thing at once.

This is indeed very true.


Thanks,

Florian Tobias Schandinat
