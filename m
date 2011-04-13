Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab1DMISB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:18:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:43437 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab1DMIQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:16:47 -0400
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gabriel Paubert <paubert@iram.es>
Cc: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Dave Airlie <airlied@gmail.com>
In-Reply-To: <20110413075943.GA27996@iram.es>
References: <20110406084101.GB13963@pengutronix.de>
	 <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com>
	 <20110406204327.GA11148@iram.es> <1302185075.24704.143.camel@thor.local>
	 <20110411133128.GA24344@iram.es> <1302535963.24704.268.camel@thor.local>
	 <20110412113033.GA16649@iram.es> <1302608770.27054.36.camel@thor.local>
	 <20110412120055.GA7995@iram.es> <1302629362.15520.25.camel@thor.local>
	 <20110413075943.GA27996@iram.es>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 18:16:13 +1000
Message-ID: <1302682573.28876.78.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 09:59 +0200, Gabriel Paubert wrote:
> 
> Well, X is dead, or rather in an infinite ioctl loop as described
> above.
> IIRC, the display enters a power-down mode and there is nothing to
> see.

So basically the card crashed. There's about an infinite amount of
reasons why radeons do so, sometimes it has to do with them not liking
what you ate that day...

The only thing I can see that could be of use would be a bisect

Cheers,
Ben.


