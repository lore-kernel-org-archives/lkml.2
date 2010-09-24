Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab0IXJMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 05:12:24 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17069 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab0IXJMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 05:12:22 -0400
Date: Fri, 24 Sep 2010 11:12:09 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [BUG 2.6.36-rc5] of_i2c.ko <-> i2c-core.ko dependency loop
Message-ID: <20100924111209.3c071da3@endymion.delvare>
In-Reply-To: <20100923150559.9c67da11.rdunlap@xenotime.net>
References: <19611.16302.262307.129176@pilspetsen.it.uu.se>
	<20100923113807.4643fbbb.rdunlap@xenotime.net>
	<19611.46496.782340.466509@pilspetsen.it.uu.se>
	<20100923150559.9c67da11.rdunlap@xenotime.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 15:05:59 -0700, Randy Dunlap wrote:
> On Thu, 23 Sep 2010 22:16:32 +0200 Mikael Pettersson wrote:
> > Randy Dunlap writes:
> >  > No kconfig warnings?
> > 
> > Not that I recall.  I can check tomorrow if necessary.
> 
> No kconfig warnings.  I checked with your .config file.
> 
> >  > Please post your full .config file.
> 
> Just a matter of module i2c-core calls of_ functions and module of_i2c calls
> i2c_ functions.  Hmph.  Something for Grant, Jean, and Ben to work out.

As far as I can see this is caused by this commit from Grant:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=959e85f7751c33d1a2dabc5cc3fe2ed0db7052e5

Mikael, can you please try reverting this patch and see if it solves
your problem?

-- 
Jean Delvare
