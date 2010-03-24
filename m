Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0CXIjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:39:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49631 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755215Ab0CXIjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:39:13 -0400
Date: Wed, 24 Mar 2010 08:43:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in
Subject: Re: [PATCH 1/7] serial: TTY: new ldisc for TI BT/FM/GPS chips
Message-ID: <20100324084307.2a07dbb1@lxorguk.ukuu.org.uk>
In-Reply-To: <20100324022803.GA4359@suse.de>
References: <1269376875-25940-1-git-send-email-pavan_savoy@ti.com>
	<1269376875-25940-2-git-send-email-pavan_savoy@ti.com>
	<20100324022803.GA4359@suse.de>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 19:28:03 -0700
Greg KH <gregkh@suse.de> wrote:

> On Tue, Mar 23, 2010 at 03:41:09PM -0500, pavan_savoy@ti.com wrote:
> > From: Pavan Savoy <pavan_savoy@ti.com>
> > 
> > A new N_TI_WL line discipline added for TI BT/FM/GPS
> > combo chips which make use of same TTY to communicate
> > with chip. This is to be made use of individual protocol
> > BT/FM/GPS drivers.
> > 
> > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > ---
> >  include/linux/tty.h |    3 ++-
> 
> Staging code needs to be completly self-contained in the drivers/staging
> directory.  Is there any way to do this without touching this file?

Put the N_TI_WL into a staging header, and bump the number of ldiscs as a
separate non staging patch - we should probably simply bump it a bit
anyway to leave room for experimental work using a built kernel image.
There is no requirement that the number of ldiscs matches up to the last
ldisc assigned.

Alan
