Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab1GLXHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 19:07:41 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:51697 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab1GLXHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 19:07:40 -0400
Message-ID: <4E1CD3AF.5070602@tlinx.org>
Date: Tue, 12 Jul 2011 16:07:27 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Gecko/20100228 Lightning/0.9 Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: device support VGA compat Matrox MGA G200ew
References: <4E1CB962.1000308@tlinx.org> <20110712222600.GA6207@electric-eye.fr.zoreil.com>
In-Reply-To: <20110712222600.GA6207@electric-eye.fr.zoreil.com>
X-Stationery: 0.5.1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Francois Romieu wrote:
> Linda Walsh <lkml@tlinx.org> :
> [...]
>   
>> The only other Matrox G200 related option under the DRM support, but it
>> says it requires /dev/agpgart to be enabled.  I know the computer doesn't
>> have an AGP 'slot' (the card is built-in), but is is possible AGP
>> would still be the choice for the interface?
>>     
>
> Yes. lspci should list an AGP bridge.
>   
----
ok...then that's not the case.

It's a built-in graphics on a server, so it's not meant to be fancy..
just provide a basic console.

> See http://ubuntuforums.org/showthread.php?t=1505532
>
> X seems to know the G200eW. It may help you figuring if
> drivers/video/matrox/* (see matroxfb_base.c for the IDs) can be made
> to work with this revision or not.
>   
----
    hmmm...  so might be a matter of the driver not recognizing the card's
specific id? 
> No idea if in-kernel DRM support still works. Imho it will fly like
> a brick.
>   
---
    yeah, well w/o agp, it's a non-issue.  I.e., it flew like lead brick.


