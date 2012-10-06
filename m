Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2JFNMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 09:12:37 -0400
Received: from smtp.getmail.no ([84.208.15.66]:43586 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab2JFNMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 09:12:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: Valdis.Kletnieks@vt.edu
Subject: Re: Linux 3.5-rc7
References: <op.wlf8shgd6426ze@localhost.localdomain>
 <49825.1349472563@turing-police.cc.vt.edu>
Date: Sat, 06 Oct 2012 15:12:33 +0200
Cc: linux-kernel@vger.kernel.org
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wlrdm7w06426ze@localhost.localdomain>
In-reply-to: <49825.1349472563@turing-police.cc.vt.edu>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2012 23:29:23 +0200, <Valdis.Kletnieks@vt.edu> wrote:

> On Sun, 30 Sep 2012 14:54:07 +0200, Uwaysi Bin Kareem said:
>> Compiled 3.6-rc7, with a hz timer of 3956 for a "natural" psychovisual
>> profile jitter level in OpenGL, and a shaved config for minimal jitter.
>
> I'll bite - how did you measure the difference between 3956 and 4000?
>
> The other stuff in your note sounds sane, but I'm having a hard time
> believing that 3956 was arrived at in any sort of systematic or measured
> way - it smells like cargo cult programming to me...

Well, you might not like the answer. It is based on purification of the  
senses by meditation. You can read about it here.  
http://www.youtube.com/watch?v=Cz8fCnMBnuc&feature=related

And then in a pure state, simply tuning the hz, to ones liking, trying to  
find a "natural value", which probably corresponds with the fact that,  
natural phenomna such as wind, temperature, influence similar phenomena to  
"jitter". Also based on 10 years of work with DSP ;)

Don`t worry about the 3956 timer anymore though, I use 90hz now. For some  
reasons many places online state higher HZ = higher resolution, and lower  
latency. For audio and opengl this is not true. Audio still has the same  
latency at 90hz, and OpenGL performs better, with less jitter.

You can take my low-jitter kernel for a spin, here.  
http://paradoxuncreated.com/Blog/wordpress/?p=2268
Particulary note that OpenGL in doom3 is very smooth, (if you have any  
jitter try killing background daemons). Audio latency is stable at 1ms,  
and few clicks at 0.3. I have also run it at 0.3ms stable latency with  
realtime threads, with a firewire audio card. Simple HDA soundchip seems  
to perform poorer for some reason. One would think that an onboard  
soundchip would have less potential latency.

The whole system runs well.

I am also using this info for thoughts on cfs. If granularity should be  
tuned up for more processes running, maybe related granuarlity to  
processes, for best resource usage. Currently also I think the 10ms filter  
could be replaced with a simpler hold logic, so you don`t have to update  
it more that neccesary, or compute share based on filters impulse response.

Just some small observations.

Peace Be With You.
