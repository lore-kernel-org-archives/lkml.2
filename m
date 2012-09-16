Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2IPUeh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 16:34:37 -0400
Received: from smtp.getmail.no ([84.208.15.66]:50037 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab2IPUeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 16:34:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
In-reply-to: <alpine.LFD.2.02.1105201819310.3078@ionos>
References: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan>
 <alpine.LFD.2.02.1105201445300.3078@ionos>
 <alpine.DEB.2.02.1105200850080.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201528500.3078@ionos>
 <alpine.DEB.2.02.1105200945300.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201712501.3078@ionos>
 <alpine.DEB.2.02.1105201210030.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201819310.3078@ionos>
Subject: Low os-jitter operating system.
To: linux-kernel@vger.kernel.org, vlc-devel@videolan.org
Date: Sun, 16 Sep 2012 22:34:33 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wkqwrvza6426ze@localhost.localdomain>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiya, I sendt this to the ubuntu suggestions box. I am emailing a copy  
here aswell.
---


Mark Shuttleworth has talked about "ultrasmooth" gaming, desktop etc. You  
can have that now already, or atleast quite close. Games will be perfect.  
Webanims and videoes will depend on syncing code or target frame rate.

First of all drop unessecary layers from the kernel. Config it for minimal  
latency. (max preemption, more preemption = less os-jitter = less latency)
Standard config usually is not configged this way, and leads to uneccesary  
chopping/frames dropped. That is not the way you want it.

Use low-jitter applications. For instance - Webkit based browsers have  
lower jitter. Resulting in smoother youtube playback among other things.  
Webanimation in general. So you`d want to use Chromium as the default  
browser.

Intelligent priorities for tasks. If you have background tasks that are  
insensitive to jitter and latency (non audio/video/net), let them have  
lower priority and only one cpu, so they are transparent to the user. Etc.  
Automatic lower priority for a wordprocessor for instance, would also fit  
the profile.

Consider system applications with lowest jitter.

This will also prepare the OS well for Wayland which is opengl based.  
Low-jitter = smoothest opengl experience.

You should also consider promoting a refresh rate of 72, as optimal.  
Research shows that many prefer 72hz refresh rate. I can personally also  
confirm that this is a nice rate, quiet and peaceful, and if one shall  
describe it a "minimal psychovisual noise" setting. More seems to only add  
noise to the screen. Less is flickery. I further tuned this to 72.734hz,  
which you can try and confirm, as a "minimal psychovisual noise" profile.
One should also inform about videos with 30fps, should have 60/90hz  
refresh rate, to avoid video-jitter. Or 25fps, 75hz etc. Similar for other  
formats. An automatically changing screenmode syncing mediaplayer would be  
optimal, with 72.734hz as standard mode, for hzadapting games or other.

Peace Be With You.

PS: If you need a video, to test with low-jitter, I have a low-jitter  
video here: This should play smoothly on a well-configged system @ 60hz  
refresh rate. Unfortunately I doubt the clocks are synced, so there still  
will be small jitter. Should not be much though.

http://paradoxuncreated.com/Blog/wordpress/?page_id=70
