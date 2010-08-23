Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0HWWPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:15:36 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:35514 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab0HWWPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:15:35 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.38
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
In-Reply-To: <20100823221119.GC2206@tux>
References: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com>
	 <1282572681.3813.3.camel@jlt3.sipsolutions.net>
	 <AANLkTimrtWQKycuAcZ3SjDaOqJ6Z-pPNauRfh+2aZ=ge@mail.gmail.com>
	 <1282579507.3405.130.camel@localhost.localdomain>
	 <20100823174620.GA12375@tux>
	 <1282597556.3405.135.camel@localhost.localdomain>
	 <20100823221119.GC2206@tux>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 23 Aug 2010 23:15:07 +0100
Message-ID: <1282601707.3405.140.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.5 (2.31.5-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 15:11 -0700, Luis R. Rodriguez wrote:
> On Mon, Aug 23, 2010 at 02:05:56PM -0700, Bastien Nocera wrote:
<snip>
> > No, I'm talking about what's exported by the providers. I don't really
> > care if they talk to other parts of the system using D-Bus though. I'm
> > talking about link 2) here.
> > 
> > [App] <-1-> [Geoclue master] <-2-> [Gypsy provider] <-3-> [Gypsy daemon]
> 
> Sorry I do not follow yet. Is the idea that you would prefer if
> client applications would never talk to providers directly and instead
> always used the master provider?

Exactly, and it's mentioned in the bugzilla, and was discussed on the
mailing-list as well.

