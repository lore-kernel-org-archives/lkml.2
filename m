Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab2IDTr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:47:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47281 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757650Ab2IDTr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:47:26 -0400
X-Sasl-enc: EM/CW113akWrC0vMmV/6rA162n1iKX21j9RvCuOc6vGX 1346788045
Date: Tue, 4 Sep 2012 12:44:55 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rupesh Gujare <rgujare@ozmodevices.com>, linux-kernel@vger.kernel.org,
        ckelly@ozmodevices.com
Subject: Re: [PATCH] staging/ozwpan: Fix zero address check in
 oz_set_active_pd
Message-ID: <20120904194455.GA10655@kroah.com>
References: <20120903191721.GX16230@one.firstfloor.org>
 <5045077F.80700@ozmodevices.com>
 <20120903195439.GY16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903195439.GY16230@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 09:54:39PM +0200, Andi Kleen wrote:
> > Its already fixed by this patch :-
> > 
> > http://driverdev.linuxdriverproject.org/pipermail/devel/2012-August/029734.html
> 
> Should be in 3.6 then as it's a bug fix.

I agree, will do.

greg k-h
