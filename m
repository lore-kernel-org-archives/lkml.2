Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab2AMO1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:27:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48113 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab2AMO1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:27:39 -0500
Date: Fri, 13 Jan 2012 22:38:36 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <kernel@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC v2 4/9] of: add clock providers
Message-ID: <20120113143832.GA1940@S2101-09.ap.freescale.net>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
 <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca>
 <20120113135036.GC17029@S2101-09.ap.freescale.net>
 <4F103A21.1050403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F103A21.1050403@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 08:05:21AM -0600, Rob Herring wrote:
> On 01/13/2012 07:50 AM, Shawn Guo wrote:
> > On Mon, Dec 12, 2011 at 03:02:04PM -0700, Grant Likely wrote:
> >> +==Clock providers==
> >> +
> >> +Required properties:
> >> +#clock-cells:	   Number of cells in a clock specifier; typically will be
> >> +		   set to 1
> > 
> > Shouldn't it be 0 typically, which means it represents only one clock
> > in the node?
> > 
> 
> We have no idea what will be typical. I would say: Typically 0 for nodes
> with a single clock output and 1 for nodes with multiple clock outputs.
> 
That's definitely better to me.

-- 
Regards,
Shawn
