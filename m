Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab1LQJVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 04:21:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57109 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab1LQJU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 04:20:59 -0500
Date: Sat, 17 Dec 2011 09:20:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Message-ID: <20111217092044.GC2833@opensource.wolfsonmicro.com>
References: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <4EE7A31E.7080301@gmail.com>
 <895CF182-4BF7-4DF5-A467-944EC008DBC3@boeing.com>
 <20111214120240.GC25088@sirena.org.uk>
 <E30C4693-0D31-4A9A-9E9D-0FC03C5F6B8A@boeing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E30C4693-0D31-4A9A-9E9D-0FC03C5F6B8A@boeing.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 02:34:37PM -0600, Moffett, Kyle D wrote:
> On Dec 14, 2011, at 07:02, Mark Brown wrote:

> > The regulator API in -next has DT bindings.

> Based on the description of our hardware, is there a good way that I
> can wire up gpio-regulator driver to our hardware with just the device
> tree (and maybe one small board-specific function) to make it shut down
> each domain in sequence at poweroff time? Otherwise I will just go back
> to my custom board-specific function for GPIO-twiddling.

No, it's a very rare use case so there's nothing off the shelf.  But it
should be straightfoward to write a device driver doing this.
