Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992906Ab2KOIEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:04:06 -0500
Received: from grimli.r00tworld.net ([83.169.44.195]:57777 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992679Ab2KOIED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:04:03 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2012 03:04:03 EST
Date: Thu, 15 Nov 2012 08:56:41 +0100
From: Mathias Krause <minipli@r00tworld.net>
To: Nithin Sujir <nsujir@broadcom.com>
Cc: David Rientjes <rientjes@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Denys Fedoryshchenko <denys@visp.net.lb>,
        Michael Chan <mchan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Latest 3.6.6 are not compiling due tg3 network driver,
	hwmon_device_unregister
Message-ID: <20121115075639.GA2031@r00tworld.net>
References: <8b566c4a9ee622737212dc17291ee238@visp.net.lb> <50A4606D.4020402@broadcom.com> <alpine.DEB.2.00.1211141929510.14414@chino.kir.corp.google.com> <DAAFBCC105999F468732FA900576CB4510069F69@IRVEXCHMB08.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DAAFBCC105999F468732FA900576CB4510069F69@IRVEXCHMB08.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 07:22:20AM +0000, Nithin Sujir wrote:
> > On Wed, 14 Nov 2012, Nithin Nayak Sujir wrote:
> > 
> > > This was fixed by
> > >
> > > commit de0a41484c47d783dd4d442914815076aa2caac2
> > > Author: Paul Gortmaker <paul.gortmaker@windriver.com>
> > > Date:   Mon Oct 1 11:43:49 2012 -0400
> > >
> > >     tg3: unconditionally select HWMON support when tg3 is enabled.
> > >
> > 
> > Would you mind submitting this for stable by following the procedure
> > described in Documentation/stable_kernel_rules.txt?
> 
> 
> Seems to have been taken into stable already. 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=aecdc33e111b2c447b622e287c6003726daa1426

No, it's not. That's the merge commit for the v3.7 merge window.

Compare this:

 $ git log --oneline --grep='tg3.*HWMON' v3.6..origin/master
 aecdc33 Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
 de0a414 tg3: unconditionally select HWMON support when tg3 is enabled.

to this:

 $ git log --oneline --grep='tg3.*HWMON' v3.6..stable/linux-3.6.y

No tg3 fix in the v3.6 stable series. But Dave may has queued it already?


Mathias
