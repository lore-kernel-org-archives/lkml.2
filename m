Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab1LTOjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 09:39:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46650 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab1LTOjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 09:39:02 -0500
Date: Tue, 20 Dec 2011 14:38:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Message-ID: <20111220143857.GU2866@opensource.wolfsonmicro.com>
References: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <4EE7A31E.7080301@gmail.com>
 <895CF182-4BF7-4DF5-A467-944EC008DBC3@boeing.com>
 <20111214120240.GC25088@sirena.org.uk>
 <E30C4693-0D31-4A9A-9E9D-0FC03C5F6B8A@boeing.com>
 <20111217092044.GC2833@opensource.wolfsonmicro.com>
 <D482A908-020C-43E0-ADFC-33AE213D7257@boeing.com>
 <20111220013819.GV2860@opensource.wolfsonmicro.com>
 <B187B965-8671-485E-9CAB-7CF3468D2ED6@boeing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B187B965-8671-485E-9CAB-7CF3468D2ED6@boeing.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 07:53:06PM -0600, Moffett, Kyle D wrote:
> On Dec 19, 2011, at 20:38, Mark Brown wrote:

> > Well, it depends what you need to do.  In the ST-Ericsson case what they
> > needed to do was collapse the core supplies for the CPU.  But previously
> > you were talking about power domains, not whole system poweroff.
> > Usually a power domain is a subset of the full system power.

> Well, I have control of 3 separate power domains in the sense that
> there are 6 physically separate computers sharing a single supply,
> with 2 in each domain (and only 1 of the 6 controlling the shared
> supply).

OK, that's really not what people commonly understand by "power domain".
This is really only about system powerdown sequencing so a custom driver
is probably fine.
