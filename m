Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1CBRV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:21:58 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:12787 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1CBRV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:21:57 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+U1dHDWaJZV4IqIM9gRl+S
Date: Wed, 2 Mar 2011 09:21:44 -0800
From: Tony Lindgren <tony@atomide.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>, peter.ujfalusi@nokia.com,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/2] twl4030_codec cleanup
Message-ID: <20110302172144.GT20560@atomide.com>
References: <1299072246-26402-1-git-send-email-ilkka.koskinen@nokia.com>
 <20110302143433.GM16181@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302143433.GM16181@sortiz-mobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

* Samuel Ortiz <sameo@linux.intel.com> [110302 06:32]:
> Hi Ilkka,
> 
> On Wed, Mar 02, 2011 at 03:24:04PM +0200, Ilkka Koskinen wrote:
> > This series of patches removes duplicate audio_mclk fields from
> > twl4030_codec driver.
> > 
> > The patches have been compiled on sound-2.6/for-2.6.39 branch.
> > I haven't tested them on any target board though.
> I'm fine with the twl.h changes, but I think it would make sense for Tony to
> take this patchset. Tony, is that ok with you ?

Sure if you prefer that.

Tony
