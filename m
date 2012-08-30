Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab2H3WuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 18:50:20 -0400
Received: from smtp.getmail.no ([84.208.15.66]:54084 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab2H3WuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 18:50:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
In-reply-to: <503D4B37.1030202@earthlink.net>
References: <op.wjrltbl46426ze@millennium.getinternet.no>
 <503D4B37.1030202@earthlink.net>
Subject: Latency.
To: linux-kernel@vger.kernel.org
Date: Fri, 31 Aug 2012 00:50:28 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wjvlqefm6426ze@millennium.getinternet.no>
User-Agent: Opera Mail/12.01 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have done some research on latency. I have config`d a linux kernel to  
run 0.3ms reliable latency with audiostreams, under normal worksituations.  
(An audioapp, and maybe some small tasks in between).

This also resulted in an extremely smooth gameplaying experience, like an  
asm-programmed custom hardware arcade. (Why gamebox-developers isn`t using  
this, is a mystery).

Recently I also tried to come as close to that experience on windows, and  
found that win32priorityseparation on 25, all processes on idle, to avoid  
cpu2 stalling cpu1, and minimal drivers, services, and processes gave a  
similar experience. Windows btw, also gives lower latency, if one moves  
windows, which one can use/abuse in a script/hack.

The feeling from low latency systems brings back the exhilaration of  
custom hardware and assembly programming. It gives a different feel, and I  
do believe it sets a high quality expectation to software and I wonder if  
that is why the Amiga is said to have so much good software, and  
responsible for it`s reputation.

My windows-partition now runs as good as an Amiga, and I managed to make  
it run even better, reminding me of singletasking systems like Mac OS.

Games are just so much more fun with this. And the overall os is so much  
more responsive.

More optimized stuff like Wayland will ofcourse even improve things more.

I do think that for "desktop" the focus should really be on low-latency  
systems.
If "desktop" and "server" are the two different profiles you usually  
config for in linux, how about two different standard configs? Or are  
these merging aswell, since I would think multi-cpu servers appreciate low  
os-jitter aswell?

Just some thoughts.

Peace Be With You.
