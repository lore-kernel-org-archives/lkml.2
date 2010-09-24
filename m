Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab0IXTv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:51:57 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:60764 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752892Ab0IXTv4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:51:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pDM8/OXekeFq0l/CBwIpcfLwh8eny+v2HVmkHzLbXjffBpYDcXWBEyrOT3SwDB57rMwUIexhnlOyIBpYVbAg9b1AJk/fXKjrZf3S1lm++JGDBuGamsv5+0mb/FOYCk/2;
Date: Fri, 24 Sep 2010 12:51:53 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: Interrupt latency on some 945GM platforms
Message-ID: <20100924125153.4fdf0c1b@jbarnes-desktop>
In-Reply-To: <201009242248.36554.anarsoul@gmail.com>
References: <201009132336.17310.anarsoul@gmail.com>
	<201009162306.59508.anarsoul@gmail.com>
	<20100924123901.243c85e1@jbarnes-desktop>
	<201009242248.36554.anarsoul@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 22:48:36 +0300
Vasily Khoruzhick <anarsoul@gmail.com> wrote:

> On 24 of September 2010 22:39:01 Jesse Barnes wrote:
> > On Thu, 16 Sep 2010 23:06:46 +0300
> > 
> > Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> > > В сообщении от 16 of September 2010 21:50:50 автор Thomas Gleixner 
> написал:
> > > > Ok. The problematic part of HPET was not the clocksource, it was the
> > > > clock event device which failed to deliver interrupts occasionally. It
> > > > was worth a try at least.
> > > 
> > > Hm, it seems that jerky glxgears is not related to jerky keyboard events.
> > > Keyboard is jerky only in konsole (kde terminal emulator), it seems
> > > something happened it seems that font rendering performance is much
> > > worse in latest xf86-video-intel than in xf86-video-intel-2.12.0.
> > 
> > Len just had me try a few things too:
> >   - maxcpus=1 lets things work
> >   - offlining cpu1 at runtime (echo 0
> > 
> >     > /sys/devices/system/cpu/cpu1/online) lets things work
> > 
> >   - binding the i915 interrupt to cpu 0 does *not* help
> > 
> > Vasily and Paolo, do you both have Atom CPUs with hyperthreading
> > enabled?
> 
> Nope, I have Core2Duo T5500, dual-core, no hyperthreading :)

Hm, well there goes the theory about Atom HT...

-- 
Jesse Barnes, Intel Open Source Technology Center
