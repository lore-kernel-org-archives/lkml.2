Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1CGQUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:20:32 -0500
Received: from kroah.org ([198.145.64.141]:45267 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab1CGQUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:20:17 -0500
Date: Mon, 7 Mar 2011 08:19:38 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steve Sakoman <steve@sakoman.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the omap_dss2
 tree
Message-ID: <20110307161938.GC9088@kroah.com>
References: <20110307165418.f17fdf4d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307165418.f17fdf4d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 04:54:18PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> arch/arm/mach-omap2/board-overo.c between commit fd045fe21361 ("OMAP:
> DSS2: Add DSS2 support for Overo") from the omap_dss2 tree and commits
> 181b250cf532 ("arm: omap: usb: create common enums and structures for
> ehci and ohci") and 9e64bb1e9f06 ("arm: omap: usb: Invoke usbhs core
> device initialization") from the usb tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks.  Felipe, am I going to have problems merging with Linus when the
.39 merge window opens up because of these omap changes in my tree?

thanks,

greg k-h
