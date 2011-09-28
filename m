Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1I1Sck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:32:40 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56437 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754906Ab1I1Scj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:32:39 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Vmk8/xdqr7qb5ag7vRE9p
Date: Wed, 28 Sep 2011 11:32:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Kyle Manna <kyle@kylemanna.com>, Russell King <linux@arm.linux.org.uk>,
        Keerthy <j-keerthy@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Fixes to twl4030-madc and add BeagleBoard
 support
Message-ID: <20110928183230.GD6324@atomide.com>
References: <CANOLnOPB=wFMPwqGbu9ufh__iM7TquUx3-o95R=gyJcae+gENg@mail.gmail.com>
 <1313119995-15382-1-git-send-email-kyle@kylemanna.com>
 <20110822135530.GR4607@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822135530.GR4607@sortiz-mobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Samuel Ortiz <sameo@linux.intel.com> [110822 06:20]:
> Hi Kyle,
> 
> On Thu, Aug 11, 2011 at 10:33:11PM -0500, Kyle Manna wrote:
> > These patches add basic functionality to the twl4030-madc driver to make
> > it work on the BeagleBoard xM.
> > 
> > Version 2 adds fixes per Grazvydas Ignotas and the check for NULL pointer patch.
> > 
> > Kyle Manna (4):
> >   mfd: twl4030-madc: copy the device pointer
> >   mfd: twl4030-madc: turn on the MADC clock
> >   mfd: twl4030-madc: check for NULL pointer
> >   arm: BeagleBoard: add support for the twl4030-madc
> Tony, are you ok with the BeagleBoard changes ?
> The MFD ones look fine to me, I'd like to apply them.

Yes sorry for the delay in replying. I acked it, maybe
you can just copy the subject to have a proper description
for the patch.

Tony
