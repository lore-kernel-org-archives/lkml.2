Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab0LPVIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:08:48 -0500
Received: from kroah.org ([198.145.64.141]:60076 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab0LPVIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:08:47 -0500
Date: Thu, 16 Dec 2010 13:08:37 -0800
From: Greg KH <greg@kroah.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 0/4] Introduce hardware spinlock framework
Message-ID: <20101216210837.GA22895@kroah.com>
References: <1291420247-18171-1-git-send-email-ohad@wizery.com>
 <AANLkTin1fd=Kei7Fo6G+uR+270HdTkc71fvsA6qjBjcA@mail.gmail.com>
 <20101214170656.GA3832@kroah.com>
 <AANLkTi=q=QMQ_Abxb8eUWT_qGG8K=pc892ZB-mqgt_mh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=q=QMQ_Abxb8eUWT_qGG8K=pc892ZB-mqgt_mh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 08:40:28PM +0200, Ohad Ben-Cohen wrote:
> On Tue, Dec 14, 2010 at 7:06 PM, Greg KH <greg@kroah.com> wrote:
> >> Can you please have a look and say if this looks OK ?
> >
> > Look at what, I don't see a patch here.
> 
> Here's the complete patchset:
> 
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg39833.html
> 
> If you prefer, I can resubmit.
> 
> >
> > I've seen a lot of discussion about this, are all of the review comments
> > now addressed?
> 
> Yes, all comments were addressed in this v3 iteration, and this thread
> has been idle for about 10 days.

That's because we are all busy with other things :(

Sorry, I really don't have the time at the moment to review this code,
nor does it seem to affect areas that I maintain, so I don't understand
what you are looking for from me.

confused,

greg k-h
