Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab1FGW7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:59:44 -0400
Received: from mta31.charter.net ([216.33.127.82]:47577 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1FGW7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:59:43 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=p9YancsnzTcA:10 a=N2sXiA72-zoA:10 a=IkcTkHD0fZMA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=iZxAJj__Qu_uhmRvLdQA:9 a=QEXdDO2ut3YA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DEEAD5D.2090406@cuw.edu>
Date: Tue, 07 Jun 2011 17:59:41 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Nicolas Palix <Nicolas.Palix@inria.fr>
CC: Julia Lawall <julia@diku.dk>, Gilles.Muller@lip6.fr, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccinelle: if(ret)return ret; return ret; semantic patch
References: <1307320012-31292-1-git-send-email-Gregory.Dietsche@cuw.edu>	<Pine.LNX.4.64.1106060651320.7113@ask.diku.dk>	<4DEE482D.7020505@cuw.edu>	<Pine.LNX.4.64.1106071855540.4074@ask.diku.dk> <BANLkTimMvG332_c4TUPefOJDDE8obowVdQ@mail.gmail.com>
In-Reply-To: <BANLkTimMvG332_c4TUPefOJDDE8obowVdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 04:54 PM, Nicolas Palix wrote:
> I remember me having worked on that but I cannot find any patch
> about it so your patch is more that welcome. Some users have requested it
> some months ago.
>
> As far as I can remember, with "M=" you can not use $srctree only but still
> need it for the -I for instance. I think I then run into a situation where I
> have an ambiguity about how to setup the flags for coccinelle, but I am sure
> about the reason I dropped my patch. Maybe I don't know well enough the build
> system and options...
>
> So, don't hesitate to submit your patch.
>    
I'll submit what I have done as a new thread / patch series. I've not 
done much testing with it and am certainly not any kind of build system 
expert, but it has worked well for me so far :) A few more people trying 
it out / testing it would be a great idea.
> Does it also update the Documentation/coccinelle.txt accordingly ?
>    
It will :)

Greg

