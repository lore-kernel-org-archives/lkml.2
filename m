Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1FFMpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:45:50 -0400
Received: from mta31.charter.net ([216.33.127.82]:63104 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab1FFMps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:45:48 -0400
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=p9YancsnzTcA:10 a=j3k67WWd678A:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=VwQbUJbxAAAA:8 a=5Ib3MncNKwioev3SiL8A:9
 a=fFJ1q3iG8Lzjn4RQPS4A:7 a=wPNLvfGTeEIA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DECCBFB.2020307@cuw.edu>
Date: Mon, 06 Jun 2011 07:45:47 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: perex@perex.cz, tiwai@suse.de, broonie@opensource.wolfsonmicro.com,
        dp@opensource.wolfsonmicro.com, lrg@ti.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wm8940: remove unecessary if statement
References: <1307321274-21858-1-git-send-email-Gregory.Dietsche@cuw.edu> <4DEC9E6B.8030505@cam.ac.uk>
In-Reply-To: <4DEC9E6B.8030505@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On 06/06/2011 04:31 AM, Jonathan Cameron wrote:
> On 06/06/11 01:47, Greg Dietsche wrote:
>    
>> the code always returns ret regardless, so if(ret) check is unecessary.
>>      
> Good point, though please spell check your commit messages.
> unecessary ->  unnecessary
>    
oops! usually I'm the guy critiquing spelling :)
> Also if you want to do this sort of cleanup, please also fix the
> equivalent in wm8940_resume and wm8940_add_widgets.  Ack is for
> what is here, plus those if you do them.
>    
I will take a look at these, but it might be a few days. I used 
coccinelle to create this patch and my semantic patch wasn't 'smart' 
enough to find them.
> Just as an aside, there is no earthly point in cc'ing lkml for a
> simple cleanup like this. Just adds to already huge amount of noise!
>    
Thanks for all of your feedback. In your opinion, what is the best way 
for someone such as myself to send patches like these? I read in 
Documentation/SubmittingPatches "Unless you have a reason NOT to do so, 
CC linux-kernel@vger.kernel.org"

Also, for this embarrassing spelling problem... do I submit a new patch? :)

Thanks,
Greg

