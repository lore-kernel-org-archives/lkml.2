Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2JGV1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 17:27:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49187 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2JGV1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 17:27:48 -0400
Message-ID: <5071F3CF.8070907@gmail.com>
Date: Sun, 07 Oct 2012 23:27:43 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@ntebb.no>
CC: linux-kernel@vger.kernel.org, alsa-devel <alsa-devel@alsa-project.org>
Subject: Re: 3.6.0 regression, distorted sound failure while using jack and
 hd-audio
References: <20121007213452.08e29880@tenkende-august.homelinux.net>
In-Reply-To: <20121007213452.08e29880@tenkende-august.homelinux.net>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc alsa-devel)

On 07.10.2012 21:34, Helge Hafting wrote:
> My sound setup works fine with 3.5.4, but have serious problems with 3.6.0
> 
> It is sound through jack that breaks, simply using "aplay" directly with the
> alsa device works.
> 
> When I use jack, my setup works fine with 3.5.4. But boot into 3.6.0,
> and I get badly distorted sound as if using an extremely overdone reverb effect. 
> And jack reports tons of xruns, several per second.
> 
> This can be worked around by going from 256 to 512 frames/period in the jack
> settings. But that also double the latency, which makes keyboard playing less
> pleasant.
> 
> It is not a case of 256 frames/period being (almost) too extreme for the machine. With kernel 3.5.4,
> I can use 128 frames/period and get mostly ok sound, with only an occational 
> xrun (and a correseponding pop in the sound). So I use 256 because that's solid.
> But with 3.6.0, not even 256 is enough. And it is not an occational pop, but
> awful distortion all the time.
> 
> I don't really know what has changed from 3.5.4 to 3.6.0. The hd-audio driver?
> Something in alsa? Or the scheduling?
> 
> Machine: Dell precision M6600 laptop, 8GB, 2.2GHz quad-core i7.
>          Usually at 800MHz to save power, this is enough for making sound.
> Kernels: 64-bit 3.5.4 or 3.6.0
> Distro: funtoo
> 
> Audio according to lspci:
> 00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 04)
> 
> Please tell if there is anything I should try. I can test other kernel versions
> or try patches.
> 
> Helge Hafting
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

