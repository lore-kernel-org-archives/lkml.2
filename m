Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0KIDHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:07:48 -0500
Received: from imr3.ericy.com ([198.24.6.13]:35484 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab0KIDHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:07:47 -0500
Date: Mon, 8 Nov 2010 19:07:23 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] include/linux/kernel.h: Add config option for
 pr_fmt(fmt)
Message-ID: <20101109030723.GA22732@ericsson.com>
References: <1287713982.16920.39.camel@Joe-Laptop>
 <20101026110335.3a4c7679@endymion.delvare>
 <1288201301.4145.122.camel@Joe-Laptop>
 <20101028093529.503c3a28@endymion.delvare>
 <1288252476.1836.9.camel@Joe-Laptop>
 <20101028104354.6aaca07c@endymion.delvare>
 <1288390250.28828.228.camel@Joe-Laptop>
 <20101108133342.7217866c@endymion.delvare>
 <20101108165526.GA20229@ericsson.com>
 <1289236563.29216.328.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1289236563.29216.328.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 12:16:03PM -0500, Joe Perches wrote:
> On Mon, 2010-11-08 at 08:55 -0800, Guenter Roeck wrote:
> > On Mon, Nov 08, 2010 at 07:33:42AM -0500, Jean Delvare wrote:
> > > Changing everything at once
> > > throughout the whole kernel tree is simply too difficult.
> > > So I hate to admit it,
> 
> I try to value my own opinion rather less highly than I used to
> so I can discount it better when I'm proven wrong.
> 
> That must come from being married...
> 
;)

> > go on with your first patchset.
> > I pretty much came to the same conclusion. No objections here anymore either.
> 
> Is there anything you need from me?
> 
I'll start applying the patches to my next tree. I'll get back to you if I run
into trouble.

Jean, do you want to take some of the patches, or should I take them all ?

Guenter
