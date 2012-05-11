Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943Ab2EKTY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:24:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972Ab2EKTY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:24:26 -0400
Date: Fri, 11 May 2012 15:24:20 -0400
From: Dave Jones <davej@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: CPU frequency drivers MAINTAINERS update
Message-ID: <20120511192420.GA10041@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux PM list <linux-pm@vger.kernel.org>
References: <20120504160417.GA421@redhat.com>
 <201205052110.03323.rjw@sisk.pl>
 <201205112116.25257.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205112116.25257.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 09:16:25PM +0200, Rafael J. Wysocki wrote:
 > On Saturday, May 05, 2012, Rafael J. Wysocki wrote:
 > > Hi Dave,
 > > 
 > > On Friday, May 04, 2012, Dave Jones wrote:
 > > > Remove myself as cpufreq maintainer.
 > > > x86 driver changes can go through the regular x86/ACPI trees.
 > > > ARM driver changes through the ARM trees.
 > > > cpufreq core changes are rare these days, and can just go to lkml/direct.
 > > > 
 > > > Signed-off-by: Dave Jones <davej@redhat.com>
 > > 
 > > Would you mind if I took over the maintenance of cpufreq, so that it goes
 > > along with the other core power management code?
 > 
 > I'm taking the silence as "no, I wouldn't". :-)

Sure. I'll still be looking at it occasionally so I'll be around to ack
things if necessary. I just don't have time to deal with build-testing
architectures I don't care about for eg, and dealing with the inevitable fallout
when things break.

The only words of advice I give to you or whoever takes over, is to push back
on adding more sysfs knobs to cpufreq. There's no end to what people want to do,
and adding "just one more knob" seems to be the default action. It's already
gotten out of hand, and more knobs aren't always the right answer.

	Dave

