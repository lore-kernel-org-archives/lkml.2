Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0LRGOx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 01:14:53 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:46441 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab0LRGOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 01:14:52 -0500
Date: Fri, 17 Dec 2010 22:14:47 -0800
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, dsd@laptop.org,
        pgf@laptop.org, James Cameron <quozl@laptop.org>
Subject: Re: [PATCH] psmouse: disable the synaptics extension on OLPC
 machines.
Message-ID: <20101217221447.375b9977@queued.net>
In-Reply-To: <20101218054927.GA14718@core.coreip.homeip.net>
References: <20101217210939.19b6111a@queued.net>
	<20101218054927.GA14718@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 21:49:28 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Fri, Dec 17, 2010 at 09:09:39PM -0800, Andres Salomon wrote:
> > 
> > OLPC has switched to a Synaptics touchpad.  It turns out that it's
> > pretty useless in absolute mode.  This patch looks for an OLPC
> > system (via DMI tables), and refuses to init Synaptics mode in
> > that scenario (falling back to relative mode).
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> Andres,
> 
> Can we do what hgpk does and add "depend on !OLPC" to the Kconfig
> instead?
> 
> Thanks.
> 

That wouldn't work for distro kernels, unfortunately.  Currently the
kernels that OLPC releases disable CONFIG_MOUSE_PS2_SYNAPTICS.  I'd
like to use a stock distribution kernel, which would need to enable
both CONFIG_OLPC *and* CONFIG_MOUSE_PS2_SYNAPTICS.. Hence the
motivation for this patch. :)
