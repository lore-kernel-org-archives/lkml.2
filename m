Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519Ab1FWOZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:25:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50353 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759507Ab1FWOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:25:31 -0400
Date: Thu, 23 Jun 2011 10:25:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alexander Holler <holler@ahsoftware.de>
cc: Arnd Bergmann <arnd@arndb.de>, <gregkh@suse.de>,
        Nicolas Pitre <nico@fluxnic.net>, <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Rabin Vincent <rabin@rab.in>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: ehci: use packed, aligned(4) instead of removing
 the packed attribute
In-Reply-To: <4E030BA6.8060407@ahsoftware.de>
Message-ID: <Pine.LNX.4.44L0.1106231022500.2033-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Alexander Holler wrote:

> Sorry, I never wanted to talk about the issue itself (I've already said 
> that), I just wanted to bring in some additional clarity for people 
> looking at the code.
> 
> I think if there is a packed,aligned(4) most people reading that are 
> able to imaging how the struct looks like, whereas nothing (without 
> packed) might leave doubts which than requires to read compiler docs or 
> the generated code, if one searches a problem in that area.

I disagree.  If there are no annotations at all (no packed), there
should be no doubts.  The compiler will add padding wherever it is
needed for internal alignment and perhaps also at the end of the
structure.  Nowhere else.

Alan Stern

