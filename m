Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750975Ab1HCGhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:37:18 -0400
Received: from lunge.queued.net ([173.255.254.236]:54423 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1HCGhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:37:14 -0400
Date: Tue, 2 Aug 2011 23:37:04 -0700
From: Andres Salomon <dilinger@queued.net>
To: Dan Williams <dcbw@redhat.com>
Cc: libertas-dev@lists.infradead.org, cjb@laptop.org,
        David Woodhouse <dwmw2@infradead.org>, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libertas: prioritize usb8388_v5.bin firmware on OLPC
 machines
Message-ID: <20110802233704.0e0d93fa@debxo>
In-Reply-To: <1312233609.3299.24.camel@dcbw.foobar.com>
References: <20110731000300.5c08e95f@debxo>
	<20110731000521.45e48638@debxo>
	<CAGq3pz75qVMuR_Hh3GKg8xK7T+_ZAW5gBZns6D6PfDYh4CF5GA@mail.gmail.com>
	<1312219075.6121.20.camel@dcbw.foobar.com>
	<20110801112522.1ba02f5e@debxo>
	<1312233609.3299.24.camel@dcbw.foobar.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Aug 2011 16:20:07 -0500
Dan Williams <dcbw@redhat.com> wrote:

> On Mon, 2011-08-01 at 11:25 -0700, Andres Salomon wrote:
> > On Mon, 01 Aug 2011 12:17:23 -0500
> > Dan Williams <dcbw@redhat.com> wrote:
> > 
> > > On Sun, 2011-07-31 at 13:59 +0100, Daniel Drake wrote:
> > > > On 31 July 2011 08:05, Andres Salomon <dilinger@queued.net>
> > > > wrote:
> > > > > Note: I've not tested this out yet on an XO-1.  I'll do that
> > > > > after some feedback regarding the matching linux-firmware pull
> > > > > request.  This should address dsd's concern about changing the
> > > > > loading order of the firmware.
> > > > 
> > > > That indeed was a concern, but only until Dan Williams and Chris
> > > > pointed out that OLPC is the only usb8388 user. With that in
> > > > mind, I am in agreement with them that simply putting
> > > > usb8388_olpc_v5.bin (or whatever name is chosen) at the top of
> > > > the firmware loading list is the best option.
> > > 
> > > Yeah, patches for that would be immediately acked.
> > > 
> > 
> > What's your opinion on overwriting usb8388_v5.bin with OLPC's
> > version, versus having both a usb8388_v5.bin and a
> > usb8388_olpc_v5.bin?
> 
> I'd slightly prefer to keep them separate, but I don't really care
> that much.  Whatever you'd like to do here is fine.
> 

Alright, since people seem to prefer keeping it around, I'll redo the
pull request (and libertas patch) to do that.


