Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1JIO1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 10:27:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36433 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1JIO1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 10:27:02 -0400
In-Reply-To: <1318140213.6216.40.camel@marge.simson.net>
References: <35C27021-40FC-4127-BC82-9F86FA9D624A@gmail.com> <1318140213.6216.40.camel@marge.simson.net>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8AF29618-6746-484D-B773-AED31FBA714D@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Robert Kubrick <robertkubrick@gmail.com>
Subject: Re: 2.6.32 / RH 6.1 scheduler bloated
Date: Sun, 9 Oct 2011 10:26:22 -0400
To: Mike Galbraith <efault@gmx.de>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will try this, but I have older kernel version running on the same  
hardware, with the same boot parameters, and showing a more  
reasonable 2us wakeup latency. Still high, but coming out of idle can  
be slow as you say.
But 10us??

On Oct 9, 2011, at 2:03 AM, Mike Galbraith wrote:

> On Sat, 2011-10-08 at 20:26 -0400, Robert Kubrick wrote:
>> A simple ftrace wakeup test shows 10us latency during the idle-to-run
>> transition:
>
> If you boot nohz=off idle=poll, and measure with cyclictest  
> (measure in
> userspace for free), you'll likely see a remarkable difference.
>
> Coming out of idle can be slow, but that has more to do with silicon
> than scheduler bloat (not that bloat doesn't exist mind you).  My  
> Q6600
> box _sucks_ at getting off it's duff, even intel_idle.max_cstate=1 is
> horrid. E5620 gets moving > order of magnitude more quickly with the
> same kernel/config/params.
>
> 	-Mike
>

