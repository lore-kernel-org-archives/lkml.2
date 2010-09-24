Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab0IXTt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:49:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62402 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab0IXTt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=duolBH2+FcHwY07cnF7cbvVg7joVM/8/6Z774IKqfjDsmhojrbqMiaEUjus/9LQRHX
         iwEvorD49IGsEwpb7dqj/RgqZIfkbh7iMpst0K30t0QhPQ/mPGPD+gGApzccR3ZaHuSP
         rc6LuNJcR/gPx1MSRlzLIwIPyhiPcUgDXSWeQ=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Interrupt latency on some 945GM platforms
Date: Fri, 24 Sep 2010 22:48:36 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.35-gentoo-r8-anarsoul; KDE/4.5.1; i686; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
References: <201009132336.17310.anarsoul@gmail.com> <201009162306.59508.anarsoul@gmail.com> <20100924123901.243c85e1@jbarnes-desktop>
In-Reply-To: <20100924123901.243c85e1@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009242248.36554.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 of September 2010 22:39:01 Jesse Barnes wrote:
> On Thu, 16 Sep 2010 23:06:46 +0300
> 
> Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> > В сообщении от 16 of September 2010 21:50:50 автор Thomas Gleixner 
написал:
> > > Ok. The problematic part of HPET was not the clocksource, it was the
> > > clock event device which failed to deliver interrupts occasionally. It
> > > was worth a try at least.
> > 
> > Hm, it seems that jerky glxgears is not related to jerky keyboard events.
> > Keyboard is jerky only in konsole (kde terminal emulator), it seems
> > something happened it seems that font rendering performance is much
> > worse in latest xf86-video-intel than in xf86-video-intel-2.12.0.
> 
> Len just had me try a few things too:
>   - maxcpus=1 lets things work
>   - offlining cpu1 at runtime (echo 0
> 
>     > /sys/devices/system/cpu/cpu1/online) lets things work
> 
>   - binding the i915 interrupt to cpu 0 does *not* help
> 
> Vasily and Paolo, do you both have Atom CPUs with hyperthreading
> enabled?

Nope, I have Core2Duo T5500, dual-core, no hyperthreading :)
