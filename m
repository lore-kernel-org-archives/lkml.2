Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1HASZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 14:25:31 -0400
Received: from lunge.queued.net ([173.255.254.236]:48213 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1HASZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 14:25:25 -0400
Date: Mon, 1 Aug 2011 11:25:22 -0700
From: Andres Salomon <dilinger@queued.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Daniel Drake <dsd@laptop.org>, cjb@laptop.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: prioritize usb8388_v5.bin firmware on OLPC
 machines
Message-ID: <20110801112522.1ba02f5e@debxo>
In-Reply-To: <1312219075.6121.20.camel@dcbw.foobar.com>
References: <20110731000300.5c08e95f@debxo>
	<20110731000521.45e48638@debxo>
	<CAGq3pz75qVMuR_Hh3GKg8xK7T+_ZAW5gBZns6D6PfDYh4CF5GA@mail.gmail.com>
	<1312219075.6121.20.camel@dcbw.foobar.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Aug 2011 12:17:23 -0500
Dan Williams <dcbw@redhat.com> wrote:

> On Sun, 2011-07-31 at 13:59 +0100, Daniel Drake wrote:
> > On 31 July 2011 08:05, Andres Salomon <dilinger@queued.net> wrote:
> > > Note: I've not tested this out yet on an XO-1.  I'll do that
> > > after some feedback regarding the matching linux-firmware pull
> > > request.  This should address dsd's concern about changing the
> > > loading order of the firmware.
> > 
> > That indeed was a concern, but only until Dan Williams and Chris
> > pointed out that OLPC is the only usb8388 user. With that in mind, I
> > am in agreement with them that simply putting usb8388_olpc_v5.bin
> > (or whatever name is chosen) at the top of the firmware loading
> > list is the best option.
> 
> Yeah, patches for that would be immediately acked.
> 

What's your opinion on overwriting usb8388_v5.bin with OLPC's version,
versus having both a usb8388_v5.bin and a usb8388_olpc_v5.bin?
