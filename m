Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0HWVGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:06:05 -0400
Received: from relay1-v.mail.gandi.net ([217.70.178.75]:42376 "EHLO
	relay1-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab0HWVGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:06:02 -0400
X-Greylist: delayed 18046 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2010 17:06:02 EDT
X-Originating-IP: 217.70.178.42
X-Originating-IP: 80.4.117.127
Subject: Re: [PATCH 0/2] iw: add GeoClue support
From: Bastien Nocera <hadess@hadess.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kevin Hayes <kevin@atheros.com>, David Quan <David.Quan@atheros.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geoclue@lists.freedesktop.org" <geoclue@lists.freedesktop.org>
In-Reply-To: <20100823174620.GA12375@tux>
References: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com>
	 <1282572681.3813.3.camel@jlt3.sipsolutions.net>
	 <AANLkTimrtWQKycuAcZ3SjDaOqJ6Z-pPNauRfh+2aZ=ge@mail.gmail.com>
	 <1282579507.3405.130.camel@localhost.localdomain>
	 <20100823174620.GA12375@tux>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 23 Aug 2010 22:05:56 +0100
Message-ID: <1282597556.3405.135.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.5 (2.31.5-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 10:46 -0700, Luis R. Rodriguez wrote:
> On Mon, Aug 23, 2010 at 09:05:07AM -0700, Bastien Nocera wrote:
> > On Mon, 2010-08-23 at 08:44 -0700, Luis R. Rodriguez wrote:
> > > 
> > > > What use is a command line tool that has to talk to a whole bunch of
> > > > daemons etc.?
> > > 
> > > The current implementation doesn't talk to deamons. The hostip
> > > provider within GeoClue and it will just trigger a URL get. If
> > > desktops start implementing a master server though then the query
> > > would simply be a cached response. 
> > 
> > Note that this error carries on in the mail. There is a master provider
> > for Geoclue that can make use of whatever providers are available, but
> > it's not in too good a shape.
> 
> I see, can you elaborate on that a little?

See the bugzillas filed against Geoclue, most of them are due to bugs in
the Geoclue master provider.

> > I'd rather somebody started fixing the Geoclue master provider rather
> > than relying on a particular service, especially when the D-Bus API for
> > the providers themselves is something we don't want to support in the
> > longer term.
> 
> Would the master provider not use Dbus for gypsy, for example?

No, I'm talking about what's exported by the providers. I don't really
care if they talk to other parts of the system using D-Bus though. I'm
talking about link 2) here.

[App] <-1-> [Geoclue master] <-2-> [Gypsy provider] <-3-> [Gypsy daemon]

