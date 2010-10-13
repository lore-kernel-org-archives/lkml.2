Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab0JMW2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 18:28:30 -0400
Received: from mail.perches.com ([173.55.12.10]:2914 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab0JMW23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 18:28:29 -0400
Subject: Re: [RFC PATCH net-next] drivers/net Documentation/networking:
 Create directory intel_wired_lan
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        e1000-devel <e1000-devel@lists.sourceforge.net>
In-Reply-To: <1286841648.26045.17.camel@Joe-Laptop>
References: <1286743352.11039.165.camel@Joe-Laptop>
	 <AANLkTikVKufQRuMGd=cdig7ff4k2aw9Q1FWwMz3pgon-@mail.gmail.com>
	 <1286841648.26045.17.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 15:28:26 -0700
Message-ID: <1287008906.1117.428.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 17:00 -0700, Joe Perches wrote:
> On Mon, 2010-10-11 at 16:52 -0700, Jeff Kirsher wrote:
> > On Sun, Oct 10, 2010 at 13:42, Joe Perches <joe@perches.com> wrote:
> > > Perhaps it's better to move drivers from the very populated
> > > drivers/net directory into vendor specific directories similar
> > > to the Atheros approach used for drivers/net/wireless/ath/
> > NAK
> > First, I think we need to keep the documentation in /Documentation/networking.
> > Second, the changes are extensive and would create a lot of regression testing.
> I don't see any actual changes here other than layout.
> What kind of regression testing do you think necessary?

Jeff?

What regression testing would actually be done?

Any new objects are trivially validated against existing
objects.

> > We have been looking at solutions like this for future
> > drivers/hardware and is on the list of items we are currently working
> > on, but feel it should not be made retroactively due to the regression
> > testing and massive changes that would need to be made.
> 
> Might as well start somewhere.



