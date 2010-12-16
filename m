Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0LPXsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 18:48:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34051 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab0LPXsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 18:48:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Regression] firewire_ohci causes system resume to fail
Date: Fri, 17 Dec 2010 00:47:56 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
References: <201012051542.31826.rjw@sisk.pl> <20101205161758.2d75c65d@stein> <20101205170947.6b4e2d09@stein>
In-Reply-To: <20101205170947.6b4e2d09@stein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012170047.56309.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 05, 2010, Stefan Richter wrote:
> On Dec 05 Stefan Richter wrote:
> > On Dec 05 Rafael J. Wysocki wrote:
> > > There is a regression I can reproduce 100% of the time on a AMD-based desktop
> > > box that resume from hibernation (or suspend) fails because of the firewire_ohci
> > > module.  The box just hangs when firewire_ohci resume runs, apparently, and it
> > > is sufficient to do:
> > > 
> > > # echo devices > /sys/power/pm_test
> > > # echo disk > /sys/power/state
> > > 
> > > to reproduce the issue.
> > 
> > Do you have anything attached to the FireWire bus?  What controller do
> > you have?
> 
> I just now tested the above on an Intel Mac mini, running
> unmodified 2.6.37-rc4 x86-32, without and with a camera on the FireWire
> port, and could not reproduce the problem.  I also got an AMD based PC
> here with an array of different FireWire controllers which I shall make
> available to the same test...

I'm unable to reproduce the problem with 2.6.37-rc6, so presumably this was
a temporary glitch with the particular kernel build.

Thanks,
Rafael
