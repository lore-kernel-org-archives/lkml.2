Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814Ab1D2Vcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:32:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:58342 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab1D2Vcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:32:41 -0400
Message-ID: <4DBB2E72.3030800@infradead.org>
Date: Fri, 29 Apr 2011 18:32:34 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Florian Mickler <florian@mickler.org>, oliver@neukum.org,
        linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media] dib0700: get rid of on-stack dma buffers
References: <1301851423-21969-1-git-send-email-florian@mickler.org> <alpine.LRH.2.00.1104040940000.31158@pub1.ifh.de>
In-Reply-To: <alpine.LRH.2.00.1104040940000.31158@pub1.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 04-04-2011 04:42, Patrick Boettcher escreveu:
> Hi Florian,
> 
> On Sun, 3 Apr 2011, Florian Mickler wrote:
> 
>> Hi,
>>
>> since I got no reaction[1] on the vp702x driver, I proceed with the
>> dib0700.
>>
>> There are multiple drivers in drivers/media/dvb/dvb-usb/ which use
>> usb_control_msg to perform dma to stack-allocated buffers. This is a bad idea
>> because of cache-coherency issues and on some platforms the stack is mapped
>> virtually and also lib/dma-debug.c warn's about it at runtime.
>>
>> Patches to ec168, ce6230, au6610 and lmedm04 were already tested and reviewed
>> and submitted for inclusion [2]. Patches to a800, vp7045, friio, dw2102, m920x
>> and opera1 are still waiting for for review and testing [3].
>>
>> This patch to dib0700 is a fix for a warning seen and reported by Zdenek
>> Kabalec in Bug #15977 [4].
>>
>> Florian Mickler (2):
>>      [media] dib0700: get rid of on-stack dma buffers
> 
> For this one we implemented an alternative. See here:
> 
> http://git.linuxtv.org/pb/media_tree.git?a=commit;h=16b54de2d8b46e48c5c8bdf9b350eac04e8f6b46
> 
> which I pushed, but obviously forgot to send the pull-request.
> 
> This is done now.

And I obviously forgot to pick ;) Ok, I'm applying Oliver Grenie's version and
marking Florian's version as superseded at patchwork.

> For the second patch I will incorperate it as soon as I find the time.

As it is a trivial fix, I'll be picking it directly.

> 
> best regards,
> -- 
> 
> Patrick
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

