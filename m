Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1AaSFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:05:22 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58708 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab1AaSFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:05:18 -0500
Date: Mon, 31 Jan 2011 11:05:12 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: John Linn <John.Linn@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lennert Buijtenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 0/8] Basic ARM device tree support
Message-ID: <20110131180512.GA15429@angua.secretlab.ca>
References: <20110118195933.13011.56098.stgit@localhost6.localdomain6>
 <00bcd596-2108-4c54-92d3-7fda39e333e3@VA3EHSMHS015.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00bcd596-2108-4c54-92d3-7fda39e333e3@VA3EHSMHS015.ehs.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 01:04:39PM -0700, John Linn wrote:
> > -----Original Message-----
> > From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> > Sent: Tuesday, January 18, 2011 1:29 PM
> > To: linux-arm-kernel@lists.infradead.org
> > Cc: Nicolas Pitre; Russell King; Catalin Marinas; devicetree-discuss@lists.ozlabs.org; linux-
> > kernel@vger.kernel.org; Olof Johansson; Jeremy Kerr; John Linn; Lennert Buijtenhek
> > Subject: [PATCH 0/8] Basic ARM device tree support
> > 
> 
> Thanks for this patch set.  Device tree on ARM will be a great help to Xilinx.
> 
> Tested-by: John Linn <john.linn@xilinx.com>

Thanks John,

I've had to rework the early init code to be safer, but it turned out
to be a significant change, so I won't add your tested-by line to the
patch yet.  Would you mind retesting when I repost later today?

Thanks,
g.

