Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab0G0TAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 15:00:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56988 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab0G0TAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 15:00:13 -0400
Date: Tue, 27 Jul 2010 14:57:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] wireless: Convert wiphy_debug macro to
 function
Message-ID: <20100727185728.GF31694@tuxdriver.com>
References: <cover.1280177971.git.joe@perches.com>
 <8e7aa541ec8fb92e1166920a4eb704aa5f851b71.1280177971.git.joe@perches.com>
 <20100727180556.GE31694@tuxdriver.com>
 <1280255665.2082.119.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280255665.2082.119.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 11:34:25AM -0700, Joe Perches wrote:
> On Tue, 2010-07-27 at 14:05 -0400, John W. Linville wrote:
> > > --- a/net/wireless/core.c
> > > +++ b/net/wireless/core.c
> > > @@ -907,3 +907,56 @@ static void __exit cfg80211_exit(void)
> > >  	destroy_workqueue(cfg80211_wq);
> > >  }
> > >  module_exit(cfg80211_exit);
> > > +
> > > +#ifdef __KERNEL__
> > 
> > Do we need this part?
> 
> No, not really.
> 
> I'm not too sure about the need for the added
> cfg80211.h #ifdef __KERNEL__ either.

Good point -- I'll remove both of them.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
