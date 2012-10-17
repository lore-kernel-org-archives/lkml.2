Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2JQWh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:37:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:53874 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab2JQWh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:37:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,603,1344236400"; 
   d="scan'208";a="205804335"
Date: Wed, 17 Oct 2012 15:37:25 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Alexis R. Cortes" <alexis.cortes@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, brian.quach@ti.com, jorge.llamas@ti.com
Subject: Re: [PATCH] usb: host: xhci: New system added for Compliance Mode
 Patch on SN65LVPE502CP
Message-ID: <20121017223725.GO5378@xanatos>
References: <507F0258.8030503@ti.com>
 <20121017203024.GB30907@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017203024.GB30907@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 01:30:24PM -0700, Greg KH wrote:
> On Wed, Oct 17, 2012 at 02:09:12PM -0500, Alexis R. Cortes wrote:
> > This minor change adds a new system to which the "Fix Compliance Mode
> > on SN65LVPE502CP Hardware" patch has to be applied also.
> > 
> > System added:
> > Vendor: Hewlett-Packard. System Model: Z1
> > 
> > Signed-off-by: Alexis R. Cortes <alexis.cortes@ti.com>
> 
> Sarah, if you don't mind, I can take this one now, it's trivial enough.
> Want to give me your ack?

Sure, looks fine.
Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>

> Also, I'm guessing that backporting it would be a good idea as well?
> I'll add the stable tree to it.

Yes, it should go back to stable trees as old as 3.2, since that was
what commit 71c731a was marked for.

Sarah Sharp
