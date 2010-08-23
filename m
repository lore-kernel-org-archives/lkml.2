Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0HWQFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:05:43 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:53536 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab0HWQFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:05:42 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.44
X-Originating-IP: 80.4.117.127
Subject: Re: [PATCH 0/2] iw: add GeoClue support
From: Bastien Nocera <hadess@hadess.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, kevin@atheros.com,
        David.Quan@atheros.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, geoclue@lists.freedesktop.org
In-Reply-To: <AANLkTimrtWQKycuAcZ3SjDaOqJ6Z-pPNauRfh+2aZ=ge@mail.gmail.com>
References: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com>
	 <1282572681.3813.3.camel@jlt3.sipsolutions.net>
	 <AANLkTimrtWQKycuAcZ3SjDaOqJ6Z-pPNauRfh+2aZ=ge@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 23 Aug 2010 17:05:07 +0100
Message-ID: <1282579507.3405.130.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.5 (2.31.5-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 08:44 -0700, Luis R. Rodriguez wrote:
> 
> > What use is a command line tool that has to talk to a whole bunch of
> > daemons etc.?
> 
> The current implementation doesn't talk to deamons. The hostip
> provider within GeoClue and it will just trigger a URL get. If
> desktops start implementing a master server though then the query
> would simply be a cached response. 

Note that this error carries on in the mail. There is a master provider
for Geoclue that can make use of whatever providers are available, but
it's not in too good a shape.

I'd rather somebody started fixing the Geoclue master provider rather
than relying on a particular service, especially when the D-Bus API for
the providers themselves is something we don't want to support in the
longer term.

Cheers

