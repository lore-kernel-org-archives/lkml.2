Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0HWWWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:22:42 -0400
Received: from [12.19.149.2] ([12.19.149.2]:28258 "EHLO mail.atheros.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab0HWWWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:22:38 -0400
Date: Mon, 23 Aug 2010 15:22:36 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bastien Nocera <hadess@hadess.net>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kevin Hayes <kevin@atheros.com>, David Quan <David.Quan@atheros.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geoclue@lists.freedesktop.org" <geoclue@lists.freedesktop.org>
Subject: Re: [PATCH 0/2] iw: add GeoClue support
Message-ID: <20100823222236.GE2206@tux>
References: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com>
 <1282572681.3813.3.camel@jlt3.sipsolutions.net>
 <AANLkTimrtWQKycuAcZ3SjDaOqJ6Z-pPNauRfh+2aZ=ge@mail.gmail.com>
 <1282579507.3405.130.camel@localhost.localdomain>
 <20100823174620.GA12375@tux>
 <1282597556.3405.135.camel@localhost.localdomain>
 <20100823221119.GC2206@tux>
 <1282601707.3405.140.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1282601707.3405.140.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 03:15:07PM -0700, Bastien Nocera wrote:
> On Mon, 2010-08-23 at 15:11 -0700, Luis R. Rodriguez wrote:
> > On Mon, Aug 23, 2010 at 02:05:56PM -0700, Bastien Nocera wrote:
> <snip>
> > > No, I'm talking about what's exported by the providers. I don't really
> > > care if they talk to other parts of the system using D-Bus though. I'm
> > > talking about link 2) here.
> > > 
> > > [App] <-1-> [Geoclue master] <-2-> [Gypsy provider] <-3-> [Gypsy daemon]
> > 
> > Sorry I do not follow yet. Is the idea that you would prefer if
> > client applications would never talk to providers directly and instead
> > always used the master provider?
> 
> Exactly, and it's mentioned in the bugzilla

Thanks for the heads up, I haven't been grep'ing through the bugzilla.

> and was discussed on the mailing-list as well.

And am new there :)

This makes sense -- are there plans on removing all these exported
library routines so that the only exposed thing is the master
provider calls?

Based on your comments it seems changing the iw patch to just
use the master provider would go more in line with current
development focus.

  Luis
