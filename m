Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0CXMyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:54:09 -0400
Received: from smtp.getmail.no ([84.208.15.66]:63804 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab0CXMyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:54:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
X-PMX-Version: 5.5.3.366731, Antispam-Engine: 2.7.0.366912,
 Antispam-Data: 2010.3.24.123929
To: linux-kernel@vger.kernel.org
Subject: Re: Optimal refresh rate for minimal psychovisual noise,
 and tuning the kernel for it.
References: <op.u900zpso6426ze@pxu>
Date: Wed, 24 Mar 2010 13:54:02 +0100
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.u92oscfg6426ze@pxu>
In-reply-to: <op.u900zpso6426ze@pxu>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 16:22:27 +0100, Uwaysi Bin Kareem  
<uwaysi.bin.kareem@paradoxuncreated.com> wrote:

> Peace Be With You.
>
> I have earlier done some work with audio, and made a limiter, which can  
> be downloaded at http://www.sourceforge.com/projects/pxu, along with  
> some other plugins.
>
> I extended the philosophy to video, and particulary the UI, and refresh  
> rate.
>
> I found that a refresh rate of approximately 72.586hz is optimal, and  
> contains the least psychovisual noise.
> Things become more lifelike, and much more information is registered by  
> the human perception.
>
> I would like to share this information with you, and a modesetting for  
> x, for 1280x1024, so you can test for yourself.
>
> I would also like to know, if there is any tunables in the linux kernel,  
> that I can tweak, to further enhance it, for 72.586hz refresh rates. I  
> have already enabled preemptive RCU, and full desktop preemption.
>
> I would also like to extend the philosophy, to the HZ setting of the  
> kernel, or other settings, and ask if anyone can make, or know patches,  
> that makes these tunables, accesible in realtime, with a cat.
>
> Peace Be With You.
>
> NB: Here is also a modeline for X, which contains the 72.586hz  
> screenmode, in 1280x1024 resolution.
>
> "1280x1024" 130.612 1280 1296 1440 1688 1024 1025 1028 1066 +hsync +vsync
>

I did try Con Kolivas BFS patch, and turned off dynticks, and set the hz  
to 2000. That seems to be the hz most complementing the "least  
psychovisual noise" target.

Things seem much more human now, the snow falling in tuxracer intro, is  
very smooth, and jitterfree, and much more human nature, in youtube videos.

Definately something for the next generation of linux machines!

Peace Be With You.
If anyone wishes to discuss this pr. mail, please contact me through  
http://www.paradoxuncreated.com
