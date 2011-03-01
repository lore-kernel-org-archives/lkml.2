Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1CAB6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 20:58:48 -0500
Received: from smtp.getmail.no ([84.208.15.66]:44915 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab1CAB6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 20:58:47 -0500
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Feb 2011 20:58:47 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Subject: Possible bug, with extreme low latency audio.
To: linux-kernel@vger.kernel.org
Date: Tue, 01 Mar 2011 01:58:43 +0100
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.vrm3n5yy6426ze@millennium>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I have shaved a kernel for features I suspected to add to os-jitter, to  
get the lowest possible latency from it.
The kernel is 2.6.36-zen0
The .config is http://www.paradoxuncreated.com/tmp/.config

What happens is, if I set my audioapp, (renoise) to extremely low  
latencies, (96khz, 8 samples buffers x 2), the audio seems to be  
distorting and speeding up, while having periods of normal playback.

With other kernel configurations, I have just experienced, glitches, which  
is typical of buffer underruns.
This kernel config though, reduces the overall os-jitter, so I could push  
the latency much lower. However then I stumbled on this problem.

Best Regards,
Uwaysi.
