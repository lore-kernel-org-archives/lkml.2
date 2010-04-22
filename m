Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab0DVUXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:23:44 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58443 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740Ab0DVUAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:16 -0400
Date: Thu, 22 Apr 2010 15:58:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Olivier Galibert <galibert@pobox.com>, Greg KH <gregkh@suse.de>,
       Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: What's the staging review and acceptance process?
Message-ID: <20100422195852.GA2391@tuxdriver.com>
References: <1271881967.1730.482.camel@Joe-Laptop.home>
 <20100422034532.GA25177@suse.de>
 <1271910357.1730.627.camel@Joe-Laptop.home>
 <20100422054902.GA28037@suse.de>
 <1271915718.1730.687.camel@Joe-Laptop.home>
 <20100422061242.GA28539@suse.de>
 <20100422064244.GA31653@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422064244.GA31653@dspnet.fr.eu.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 08:42:45AM +0200, Olivier Galibert wrote:
> On Wed, Apr 21, 2010 at 11:12:42PM -0700, Greg KH wrote:
> > On Wed, Apr 21, 2010 at 10:55:18PM -0700, Joe Perches wrote:
> > > Not really, patchwork shows status immediately.
> > 
> > Immediately when someone does something with it, right?  So, the same as
> > my development cycle?
> 
> I guess the main difference is that patchwork allows one contributor
> to see that his patch has just not been checked yet, vs. missed/lost.

In Greg's defense, I find patchwork to be fairly unwieldy (which is
why I don't use it).  It is certainly possible that I am missing some
key feature, but my limited experience with it suggested to me that all
the clicky-clicky stuff required to deal with the individual messages
queued in patchwork nearly doubled my time overhead associated with
merging patches.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
