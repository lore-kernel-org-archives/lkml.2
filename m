Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1HIPz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:55:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab1HIPz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:55:27 -0400
Date: Tue, 9 Aug 2011 08:25:24 -0700
From: Greg KH <gregkh@suse.de>
To: Martyn Welch <martyn.welch@ge.com>
Cc: cota@braap.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] staging: vme: rename *_slot_get to *_get_slot
Message-ID: <20110809152524.GA5697@suse.de>
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-7-git-send-email-manohar.vanga@cern.ch>
 <4E369C26.5040300@ge.com>
 <20110801123121.GA7130@becoht-mvanga>
 <4E414FC0.8070700@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E414FC0.8070700@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 04:18:24PM +0100, Martyn Welch wrote:
> On 01/08/11 13:31, Manohar Vanga wrote:
> > Hi Martyn,
> > 
> >> If your doing vme_slot_get, then there's also vme_lm_get, vme_master_get and
> >> vme_slave_get.
> >>
> >> Doing just this would then lead to more inconsistency in the naming and
> >> wouldn't even get rid of all the functions using the *_get naming convention.
> > 
> > I can simply change those as well and resend :)
> > 
> >> I'm not sure this change is worth it.
> > 
> > I thought it would be worth changing this especially with the addition of bridge
> > refcounting functions (which have the *_get/_set convention).
> > 
> 
> The naming of the API is reasonably consistent at the moment. It looks like we
> aren't going to need to export vme_bus_get and vme_bus_put based on the
> conversation on patch 5. In addition to this, I've discovered that the
> functions for USB are actually called usb_get_dev and usb_put_dev, so the
> *_put/get convention isn't very strictly adhered to. I'd prefer to keep the
> API as is.

It's not that strict, so I wouldn't worry about changing the names, as
it's obvious what is happening.

greg k-h
