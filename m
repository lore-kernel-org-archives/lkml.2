Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab1DMU3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:29:03 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:55973 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757492Ab1DMU3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:29:01 -0400
X-Greylist: delayed 1640 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Apr 2011 16:29:01 EDT
Message-ID: <4DA60126.6030003@ukfsn.org>
Date: Wed, 13 Apr 2011 21:01:42 +0100
From: Andy Furniss <andyqos@ukfsn.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.18) Gecko/20110320 SeaMonkey/2.0.13
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@daenzer.net>
CC: Gabriel Paubert <paubert@iram.es>, KH <greg@kroah.com>,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, Greg@freedesktop.org,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
References: <20110406204327.GA11148@iram.es>	<1302185075.24704.143.camel@thor.local>	<20110411133128.GA24344@iram.es>	<1302535963.24704.268.camel@thor.local>	<20110412113033.GA16649@iram.es>	<1302608770.27054.36.camel@thor.local> <20110412120055.GA7995@iram.es>	<1302629362.15520.25.camel@thor.local> <20110413075943.GA27996@iram.es>	<1302696736.15520.63.camel@thor.local> <20110413122751.GA21050@iram.es> <1302704124.15520.72.camel@thor.local>
In-Reply-To: <1302704124.15520.72.camel@thor.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Dänzer wrote:

>>> That does sound like the GPU locks up. Do you get any messages in dmesg
>>> about lockups and attempts to reset the GPU at any time?
>>
>> No.
>
> Hmm, I guess the constant SIGALRMs might prevent the lockup detection
> from kicking in... Maybe you can try starting the X server with
> -dumbSched to see if that gets things along any further, but in the end
> there's probably no way around figuring out what causes the lockup and
> fixing that anyway.

I have an old AGP box that locks with 600g + agpgart - It used to give 
GPU lockup to dmesg/log, but (I only test it occasionally) it doesn't 
anymore. I can still sysrq OK.

I wonder if something changed in recent months in the drm/whatever code 
that has changed/blocked the logging.
