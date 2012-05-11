Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945965Ab2EKT3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:29:12 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39401 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932708Ab2EKT3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:29:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Subject: Re: CPU frequency drivers MAINTAINERS update
Date: Fri, 11 May 2012 21:34:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <20120504160417.GA421@redhat.com> <201205112116.25257.rjw@sisk.pl> <20120511192420.GA10041@redhat.com>
In-Reply-To: <20120511192420.GA10041@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205112134.02273.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 11, 2012, Dave Jones wrote:
> On Fri, May 11, 2012 at 09:16:25PM +0200, Rafael J. Wysocki wrote:
>  > On Saturday, May 05, 2012, Rafael J. Wysocki wrote:
>  > > Hi Dave,
>  > > 
>  > > On Friday, May 04, 2012, Dave Jones wrote:
>  > > > Remove myself as cpufreq maintainer.
>  > > > x86 driver changes can go through the regular x86/ACPI trees.
>  > > > ARM driver changes through the ARM trees.
>  > > > cpufreq core changes are rare these days, and can just go to lkml/direct.
>  > > > 
>  > > > Signed-off-by: Dave Jones <davej@redhat.com>
>  > > 
>  > > Would you mind if I took over the maintenance of cpufreq, so that it goes
>  > > along with the other core power management code?
>  > 
>  > I'm taking the silence as "no, I wouldn't". :-)
> 
> Sure. I'll still be looking at it occasionally so I'll be around to ack
> things if necessary.

Cool, thanks!

> I just don't have time to deal with build-testing
> architectures I don't care about for eg, and dealing with the inevitable fallout
> when things break.

Sure.

> The only words of advice I give to you or whoever takes over, is to push back
> on adding more sysfs knobs to cpufreq. There's no end to what people want to do,
> and adding "just one more knob" seems to be the default action. It's already
> gotten out of hand, and more knobs aren't always the right answer.

I agree.

Thanks a lot,
Rafael
