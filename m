Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab2JQUap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 16:30:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56331 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab2JQUa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 16:30:28 -0400
Date: Wed, 17 Oct 2012 13:30:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Alexis R. Cortes" <alexis.cortes@ti.com>, sarah.a.sharp@linux.intel.com
Cc: sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, brian.quach@ti.com, jorge.llamas@ti.com
Subject: Re: [PATCH] usb: host: xhci: New system added for Compliance Mode
 Patch on SN65LVPE502CP
Message-ID: <20121017203024.GB30907@kroah.com>
References: <507F0258.8030503@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507F0258.8030503@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 02:09:12PM -0500, Alexis R. Cortes wrote:
> This minor change adds a new system to which the "Fix Compliance Mode
> on SN65LVPE502CP Hardware" patch has to be applied also.
> 
> System added:
> Vendor: Hewlett-Packard. System Model: Z1
> 
> Signed-off-by: Alexis R. Cortes <alexis.cortes@ti.com>

Sarah, if you don't mind, I can take this one now, it's trivial enough.
Want to give me your ack?

Also, I'm guessing that backporting it would be a good idea as well?
I'll add the stable tree to it.

greg k-h
