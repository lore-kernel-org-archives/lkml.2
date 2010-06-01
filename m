Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab0FADPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:15:14 -0400
Received: from mail.tmr.com ([64.65.253.246]:51415 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab0FADPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:15:12 -0400
Message-ID: <4C047B38.9050506@tmr.com>
Date: Mon, 31 May 2010 23:15:04 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: alex.buell@munted.org.uk,
       Mailing Lists - Kernel Developers 
	<linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>
Subject: Re: Article in Phoronix about loss of performance in 2.6.35 release
 candidates
References: <1275347969.29006.5.camel@lithium.local.net> <4C0448B5.7090904@gmail.com>
In-Reply-To: <4C0448B5.7090904@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> On 05/31/2010 05:19 PM, Alex Buell wrote:
>> http://www.phoronix.com/vr.php?view=14976
>>
>> Question: Why?
> 
> Good question.. I guess it would too much to ask of them to try to 
> figure out what area the problem lies in (even to the point of figuring 
> out if it's a CPU or IO-bound problem), or try to bisect, or at least 
> report it to LKML before going to the trouble of creating 5 pages of 
> graphs.. Given the 20x slowdown in some of the benchmarks you'd think it 
> wouldn't be too hard to narrow down.

That's true, but 20x should be too hard for people to detect when they do QA 
after creating a patch, before sending it to LKML in the first place, either. If 
such a regression made it to an -rc1 then it really is kind of a big deal. Of 
course Phoronics running the tests on netbook processors is probably a good 
thing, I doubt many developers and testers are compiling kernels on a rig like 
that, or doing much of anything else demanding.

I guess I would expect people to react with dismay to the fact that such a 
problem made it undetected to rc stage, but perhaps I have too much respect for 
developers. This looks more like "how dare they not keep it quiet and just tell 
us" indignation. In the end I doubt it makes a lot of difference, if someone 
posted to LKML and Slashdot picked it up, be sure it would have hit the media 
anyway.

Should any media keep a defect quiet when they make their living informing the 
readers? I see a lot of glee among Linux users every few days when a new Windows 
bug becomes public. Phoronics tested and reported, why is that less honorable 
than Tom's Hardware telling us a new CPU sucks?


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
