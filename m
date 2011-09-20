Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab1ITTzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:55:25 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43460 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967Ab1ITTzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:55:23 -0400
X-Sasl-enc: WOeawUlIrppCuiDxHoQ2nvRxBkICqiH6DyS1onpEunp0 1316548522
Date: Tue, 20 Sep 2011 12:52:05 -0700
From: Greg KH <greg@kroah.com>
To: Dave Kilroy <kilroyd@googlemail.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, pe1dnn@amsat.org
Subject: Re: [PATCH 3/3] staging: wlags49_h2: Declare support for WEXT 21
Message-ID: <20110920195205.GA27739@kroah.com>
References: <1316462896-17846-1-git-send-email-kilroyd@googlemail.com>
 <1316462896-17846-4-git-send-email-kilroyd@googlemail.com>
 <15411.1316463771@turing-police.cc.vt.edu>
 <4E77A9B1.1040107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E77A9B1.1040107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 09:44:33PM +0100, Dave Kilroy wrote:
> On 19/09/2011 21:22, Valdis.Kletnieks@vt.edu wrote:
> >On Mon, 19 Sep 2011 21:08:16 BST, David Kilroy said:
> >>There may be a few areas where we don't actually support WE21,
> >>but by doing this it will make it easier to find those places.
> >
> >I'll bite - what happens when we find such a place?  Kernel fails to build, or
> >user has a suboptimal usage experience, or?
> 
> The user would have a sub-optimal experience. iwconfig may not
> display a few things correctly (ESSID?) in particular scenarios.
> 
> The reason I included this patch was that I'm not sure whether
> wpa-supplicant requires WEXT version to be above a certain threshold
> to use the events in the previous patch. I'm happy to drop this one
> if it just works.
> 
> >What are the expected chances that sticking this in linux-next for a cycle will
> >result in most/all of the places being found before this all appears in an
> >official release?  I'm thinking this should probably go in linux-next right after
> >the next merge window closes, to maximize the chances we'll shake it
> >all out during almost 2 cycles before it hits the streets. (And yes, I know
> >it's a staging/ driver - if somebody else says "one cycle is more than enough"
> >I'm OK with that too...)
> 
> This hardware is old, and as far as I can tell quite rare. I'd hope
> we can get some feedback from Henk on the series before applying
> this patch.

I've applied the first 2 of these, if you want me to apply the third
one, please resend it after it's been tested by someone.

thanks,

greg k-h
