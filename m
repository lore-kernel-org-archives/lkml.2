Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2GaViu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 17:38:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53588 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2GaVir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 17:38:47 -0400
Date: Tue, 31 Jul 2012 14:38:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexis Cortes <x0095842@dsbmail.itg.ti.com>, alexis.cortes@ti.com
Cc: sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, brian.quach@ti.com, jorge.llamas@ti.com
Subject: Re: [PATCH] usb: host: xhci: Fix Compliance Mode on SN65LVPE502CP
 Hardware
Message-ID: <20120731213841.GA25605@kroah.com>
References: <50184BF4.6080102@dsbmail.itg.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50184BF4.6080102@dsbmail.itg.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 04:19:48PM -0500, Alexis Cortes wrote:

That's some "From:" line in your patch, are you sure that is right?

> This patch is intended to work around a known issue on the
> SN65LVPE502CP USB3.0 re-driver that can delay the negotiation
> between a device and the host past the usual handshake timeout,
> and if that happens on the first insertion, the host controller
> port will enter in Compliance Mode as per xHCI Spec. The patch
> creates a timer which polls every 2 seconds the link state of each
> host controller's port (this by reading the PORTSC register) and
> recovers the port by issuing a Warm reset every time Compliance mode
> is detected.
> 
> Signed-off-by: Alexis R. Cortes <alexis.cortes@ti.com>

Odds are you want this address there, right?  If so, please put it in
the first line of the patch comments, as described in the
Documentation/SubmittingPatches file.

> ---
>  drivers/usb/host/xhci-hub.c |   27 ++++++++++++++
>  drivers/usb/host/xhci.c     |   81
> +++++++++++++++++++++++++++++++++++++++++++

Your patch is linewrapped and can not be applied :(

Care to try again?

greg k-h
