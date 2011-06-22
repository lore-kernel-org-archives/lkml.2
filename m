Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab1FVAMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 20:12:50 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43036 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504Ab1FVAMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 20:12:44 -0400
X-Sasl-enc: kKKxotd0tHXl2EDEGEMpW316CTQIC5PtTWSz3Ji5MCc4 1308701563
Date: Tue, 21 Jun 2011 17:11:18 -0700
From: Greg KH <greg@kroah.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Marc Koschewski <marc@osknowledge.org>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mei driver breaks suspend on 3.0git
Message-ID: <20110622001118.GB9627@kroah.com>
References: <201106121314.26394.a.miskiewicz@gmail.com>
 <201106122016.33399.a.miskiewicz@gmail.com>
 <201106122038.36623.a.miskiewicz@gmail.com>
 <201106122040.21950.a.miskiewicz@gmail.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401AD318B15@hasmsx504.ger.corp.intel.com>
 <20110621183954.GA17528@marc.osknowledge.org>
 <6F5C1D715B2DA5498A628E6B9C124F0401B87DC7EA@hasmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F0401B87DC7EA@hasmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:07:27PM +0300, Winkler, Tomas wrote:
> 
> 
> > -----Original Message-----
> > From: Marc Koschewski [mailto:marc@osknowledge.org]
> > Sent: Tuesday, June 21, 2011 9:40 PM
> > To: Winkler, Tomas
> > Cc: Arkadiusz Miskiewicz; Weil, Oren jer; linux-kernel@vger.kernel.org
> > Subject: Re: mei driver breaks suspend on 3.0git
> > 
> > * Winkler, Tomas <tomas.winkler@intel.com> [2011-06-12 22:41:59 +0300]:
> > 
> > I suffer the same. After booting 3.0.0-r4 with that module not being loaded it
> > suspends, however, it doesn't resume (screen black, hard power-off
> > needed).
> 
> The patch was already posted https://lkml.org/lkml/2011/6/13/148 but wasn't picked up for rc4 yet. 
> For now please apply it your by yourself.
> 
>  Greg, will you collect staging fixes for rc5 or shell it be picked up directly by Linus?

I will get it and send it to Linus.

Sorry, I'm on vacation this week and have no real email access...

greg k-h
