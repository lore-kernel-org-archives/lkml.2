Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab1DMJTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:19:24 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:55692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab1DMJTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:19:23 -0400
Subject: Re: [PATCH v2] rfkill: Regulator consumer driver for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <20110413104402.d0115659.ospite@studenti.unina.it>
References: <1302082178.3811.7.camel@jlt3.sipsolutions.net>
	 <1302260395-11872-1-git-send-email-ospite@studenti.unina.it>
	 <1302608488.3639.15.camel@jlt3.sipsolutions.net>
	 <1302608642.3639.17.camel@jlt3.sipsolutions.net>
	 <20110413104402.d0115659.ospite@studenti.unina.it>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 11:19:16 +0200
Message-ID: <1302686356.3731.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 10:44 +0200, Antonio Ospite wrote:
> On Tue, 12 Apr 2011 13:44:02 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > On Tue, 2011-04-12 at 13:41 +0200, Johannes Berg wrote:
> > 
> > > > + * static struct regulator_consumer_supply pcap_regulator_V6_consumers [] = {
> > > > + * 	{ .dev_name = "rfkill-regulator.0", supply = "vrfkill" },
> > > > + * };
> > > 
> > > It's a comment, but it should be .supply = (missing the .)
> > >
> 
> well spotted, I'll fix this.

This is the comment I was referring to -- I got confused and thought
this was a struct rfkill_regulator_platform_data.

> That's how the regulator framework works, I know Mark already replied to
> you but I try to elaborate more for the records and to organize my 
> thoughts about that:
[snip explanation]

Thanks, ok, I'm just not familiar with the regulator framework and got
confused about the various structs involved.

So the only thing I see wrong is the missing . above, not sure if you
care enough to resend :-)

johannes

