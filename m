Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1FFU65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:58:57 -0400
Received: from mta21.charter.net ([216.33.127.81]:52471 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1FFU6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:58:55 -0400
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=p9YancsnzTcA:10 a=j3k67WWd678A:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=OeLhE_-LqMPHxz7CbD8A:9
 a=t7j9Nbo1v-DgU4PPCIwA:7 a=wPNLvfGTeEIA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DED3F8E.60400@cuw.edu>
Date: Mon, 06 Jun 2011 15:58:54 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: perex@perex.cz, tiwai@suse.de, broonie@opensource.wolfsonmicro.com,
        dp@opensource.wolfsonmicro.com, lrg@ti.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wm8940: remove unecessary if statement
References: <1307321274-21858-1-git-send-email-Gregory.Dietsche@cuw.edu> <4DEC9E6B.8030505@cam.ac.uk> <4DECCBFB.2020307@cuw.edu> <4DECD0B1.4010802@cam.ac.uk>
In-Reply-To: <4DECD0B1.4010802@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On 06/06/2011 08:05 AM, Jonathan Cameron wrote:
> On 06/06/11 13:45, Greg Dietsche wrote:
>    
>
>>> Also if you want to do this sort of cleanup, please also fix the
>>> equivalent in wm8940_resume and wm8940_add_widgets.  Ack is for
>>> what is here, plus those if you do them.
>>>
>>>        
I updated the patch to include these too.
>>> Just as an aside, there is no earthly point in cc'ing lkml for a
>>> simple cleanup like this. Just adds to already huge amount of noise!
>>>
>>>        
...and remove LKML from the CC list... :)
> Fair enough.  The posting to lkml makes more sense now I know it came
> out of coccinelle (I guess with a load of others? - if so convention would be
>    
a handful... not too many, but it sounds like if my semantic patch were 
to be improved,
there might be a few more.
> to put them all in a series cc'ing the relevant lists / maintainers for individual
> patches in the series - that way everyone knows what is going on).
>
> If it is an individual patch like this, then use apply common sense. It makes
> no functional changes + is well within a subsystem with it's own active mailing
> list.  It needs to be sent somewhere publicly, but in this case
> I'd say alsa-devel is the right destination.  The only people who are even going
> to read this are the subsystem maintainer, the driver author or the chronically
> bored.
>
> Also I think convention is to have the script somewhere (cover letter to that
> series perhaps?).  See the other series people have done with coccinelle and
> how they handled this.
>    
>
Thanks so much for the great explanation being patient with a kernel 
newbie :)

Greg

