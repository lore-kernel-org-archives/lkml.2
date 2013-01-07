Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab3AGGWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 01:22:25 -0500
Received: from mail-gh0-f178.google.com ([209.85.160.178]:62610 "EHLO
	mail-gh0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3AGGWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 01:22:23 -0500
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2013 01:22:23 EST
Date: Sun, 6 Jan 2013 22:11:13 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "Tc, Jenny" <jenny.tc@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/2] power_supply: Add charge control struct in power
 supply class
Message-ID: <20130107061113.GA26891@lizard.gateway.2wire.net>
References: <1354002423-24587-1-git-send-email-ramakrishna.pallala@intel.com>
 <1354002423-24587-2-git-send-email-ramakrishna.pallala@intel.com>
 <20130106025024.GC6919@lizard.sbx05280.losalca.wayport.net>
 <D854C92F57B1B347B57E531E78D05EAD245CAF83@BGSMSX102.gar.corp.intel.com>
 <20ADAB092842284E95860F279283C564E70A93@BGSMSX101.gar.corp.intel.com>
 <D854C92F57B1B347B57E531E78D05EAD245CB0F3@BGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD245CB0F3@BGSMSX102.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 05:43:58AM +0000, Pallala, Ramakrishna wrote:
> > > > > +struct power_supply_charger_control {
> > > > > +	const char *name;
> > > > > +	/* get charging status */
> > > > > +	int (*is_charging_enabled)(void);
> > > > > +	int (*is_charger_enabled)(void);
[...]
> > The similar functionalities are exposed by patch
> > https://lkml.org/lkml/2012/10/18/219.
> > As per Anton's review comments on this patch, I'll be moving the macros to
> > power_supply.h.
> > Wouldn't that be enough ?
> 
> Though the macros seem to be fine but I would still think that call back way of interfaces would be
> More flexible and straightforward.

We have properties mechanism deployed already, so I'd rather keep it
consistent.

p.s. We had 'properties vs. callbacks' debates before, there are pros and
cons of each approach. Unless there are some unresolvable issues, let's
stick with the original approach. :)
