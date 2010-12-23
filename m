Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0LWPCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:02:15 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48252 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab0LWPCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:02:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-face:face:x-url:x-pgp-fp
         :x-pgp:date:in-reply-to:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=H86UtXVl+Zbf11irmvuv6EMKSmroU8Ae3V7mIf+yKZ0Owil/vDBYpH8210DH6gwvy2
         s0/5PZkp8brdccwuajYCf5VnmLX/lifypWFbSTUKIBj/THXZCI4z6iMj5KfOxhu7ecoJ
         +NcAbdqQhb1ktda+dHA19SmA+1RYXvau7NPwA=
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Fujak <t.fujak@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kyungmin Park <kmpark@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Ankita Garg <ankita@in.ibm.com>
Subject: Re: [PATCHv8 00/12] Contiguous Memory Allocator
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
	<AANLkTim8_=0+-zM5z4j0gBaw3PF3zgpXQNetEn-CfUGb@mail.gmail.com>
	<20101223100642.GD3636@n2100.arm.linux.org.uk>
	<00ea01cba290$4d67f500$e837df00$%szyprowski@samsung.com>
	<20101223121917.GG3636@n2100.arm.linux.org.uk>
	<4D135004.3070904@samsung.com>
	<20101223134838.GK3636@n2100.arm.linux.org.uk>
	<4D1356D7.2000008@samsung.com>
	<20101223141608.GM3636@n2100.arm.linux.org.uk>
	<AANLkTinzsOom5awOr6Y8e7PKRbCWYQOqEbdw9is6HroR@mail.gmail.com>
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Thu, 23 Dec 2010 16:02:07 +0100
In-Reply-To: <AANLkTinzsOom5awOr6Y8e7PKRbCWYQOqEbdw9is6HroR@mail.gmail.com>
	(Felipe Contreras's message of "Thu, 23 Dec 2010 16:42:57 +0200")
Message-ID: <87d3osedn4.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Thu, Dec 23, 2010 at 03:04:07PM +0100, Tomasz Fujak wrote:
>>> In other words, should we take your response as yet another NAK?
>>> Or would you try harder and at least point us to some direction that
>>> would not doom the effort from the very beginning.

> On Thu, Dec 23, 2010 at 4:16 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> What the fsck do you think I've been doing?  This is NOT THE FIRST time
>> I've raised this issue.  I gave up raising it after the first couple
>> of attempts because I wasn't being listened to.
>>
>> You say about _me_ not being very helpful.  How about the CMA proponents
>> start taking the issue I've raised seriously, and try to work out how
>> to solve it?  And how about blaming them for the months of wasted time
>> on this issue _because_ _they_ have chosen to ignore it?

Felipe Contreras <felipe.contreras@gmail.com> writes:
> I've also raised the issue for ARM. However, I don't see what is the
> big problem.
>
> A generic solution (that I think I already proposed) would be to
> reserve a chunk of memory for the CMA that can be removed from the
> normally mapped kernel memory through memblock at boot time. The size
> of this memory region would be configurable through kconfig. Then, the
> CMA would have a "dma" flag or something, 

Having exactly that usage in mind, in v8 I've added notion of private
CMA contexts which can be used for DMA coherent RAM as well as memory
mapped devices.

> and take chunks out of it until there's no more, and then return
> errors. That would work for ARM.

-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
