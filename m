Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0CWPPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:15:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37195 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754432Ab0CWPPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:15:06 -0400
Date: Tue, 23 Mar 2010 15:18:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: pavan_savoy@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] drivers:misc: Kconfig, Makefile for TI's ST ldisc
Message-ID: <20100323151852.7c4c30b7@lxorguk.ukuu.org.uk>
In-Reply-To: <20100322213530.GC420@suse.de>
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com>
	<1269292756-7469-2-git-send-email-pavan_savoy@ti.com>
	<1269292756-7469-3-git-send-email-pavan_savoy@ti.com>
	<20100322213530.GC420@suse.de>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010 14:35:30 -0700
Greg KH <gregkh@suse.de> wrote:

> On Mon, Mar 22, 2010 at 04:19:12PM -0500, pavan_savoy@ti.com wrote:
> > From: Pavan Savoy <pavan_savoy@ti.com>
> > 
> > This change adds the Kconfig and Make file for TI's
> > ST line discipline driver and the BlueZ driver for BT
> > core of the TI BT/FM/GPS combo chip.
> > 
> > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > ---
> >  drivers/misc/Kconfig        |    1 +
> 
> Why 'misc'?  Why not 'char' like all the other ldiscs?
> 
> Or 'drivers/ldisc' to be more specific?

We've discussed having /tty or drivers/tty for a while. The ldiscs are
currently everywhere - drivers/net, isdn, char ....

I am not sure an ldisc directory helps though - slip and ppp are in
drivers/net for example and clearly belong there.
