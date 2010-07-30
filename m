Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab0G3WTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 18:19:04 -0400
Received: from kroah.org ([198.145.64.141]:38783 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab0G3WTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 18:19:00 -0400
Date: Fri, 30 Jul 2010 15:16:20 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv5 2/3] USB: gadget: Use new composite features in some
 gadgets
Message-ID: <20100730221620.GA20092@kroah.com>
References: <20100730212131.GA8787@kroah.com>
 <842657.61658.qm@web180308.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <842657.61658.qm@web180308.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 03:01:50PM -0700, David Brownell wrote:
> 
> > > That's too extreme; the original handful of
> > > NetChip IDs were (and are!!) correctly assigned,
> > > and there's no reason to change them.  In fact,
> > > there's a lot of reason to continue using them
> > > while config files and drivers expect to see
> > > those specific IDs (as is reasonable).  That's
> > > to avoid breaking working configs...
> > 
> > True, I was thinking that for the class-type devices, we
> > could use the
> > linux foundation vid, as changing them shouldn't
> > matter right?
> 
> There are INF files using NetChip IDs, so
> changing them would break stuff.
> 
> Newer interfaces using new VIDS/PIDS?  Fine.
> > 
> > Or does Windows really care about the vid/pid for
> > a class device somehow?
> 
> My understanding is that it does, since it really
> doesn't have a good concept of "class" being the
> generic thing.  INF files embed VIDS/PIDS even
> for drivers implementing class specs.  MSFT was
> being stupid again...

Ok, fair enough.

thanks,

greg k-h
