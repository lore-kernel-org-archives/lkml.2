Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008Ab0HFWJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:09:57 -0400
Received: from lucidpixels.com ([75.144.35.66]:60038 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761842Ab0HFWJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:09:55 -0400
Date: Fri, 6 Aug 2010 18:09:54 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: 2.6.35: cpu_idle bug report / on i7 870 cpu (x86_64)
Message-ID: <alpine.DEB.2.00.1008061800530.5241@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When cpu_idle is used alongside a core i7 cpu w/cpufreq, the system 
exhibits delays when typing into a terminal via ssh or VNC, I had changed 
a few options from 2.6.34 -> 2.6.35 and did not think the cpu_idle would 
be at fault; however, after going through all of the options and disabling 
it, the problem went away.

< >   Cpuidle Driver for Intel Processors

The system lags every so often when cpu_idle is enabled.  It is quite 
annoying.

All disk subsystems/CPU/etc are OK-- that option causes some nasty side 
effects.

Kernel config: (w/cpu_idle) - exhibits the problem.
http://home.comcast.net/~jpiszcz/20100806/config-20100806.1281129405

Removed cpu_idle, problem is gone.
http://home.comcast.net/~jpiszcz/20100806/config-20100806.1281131518

In addition, sometimes the system did not reboot (instead I hear the 
speaker whining solid, not beeping, just a constant whine).

And sometimes it failed to reboot between kernel rebuilds.

After cpu_idle has been removed from the kernel, all problems have went 
away.

This may have already been reported but I did not find anything on it.

Is this driver safe for i7 CPUs and/or who should be using it?

Justin.
