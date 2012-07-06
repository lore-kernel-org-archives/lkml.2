Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab2GFRgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:36:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35275 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757652Ab2GFRgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:36:37 -0400
X-Sasl-enc: ujUHs+L0mfwyobqCfD8MyXTxRo+ovgHEcyisxqhgUtuZ 1341596197
Date: Fri, 6 Jul 2012 10:36:35 -0700
From: Greg KH <greg@kroah.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/tile: provide kernel support for the tilegx USB
 shim
Message-ID: <20120706173635.GB2373@kroah.com>
References: <201206162048.q5GKm1rt019464@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206162048.q5GKm1rt019464@farm-0002.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 12:25:02PM -0400, Chris Metcalf wrote:
> This change adds support for accessing the USB shim from within the
> kernel.  Note that this change by itself does not allow the kernel
> to act as a host or as a device; it merely exposes the built-in on-chip
> hardware to the kernel.

What do you mean by this?  This is needed for the other patches, right?
If so, I'm guessing they are going through the tile tree?  That's fine
with me.

thanks,

greg k-h
