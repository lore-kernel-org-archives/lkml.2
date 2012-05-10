Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866Ab2EJSSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:18:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51556 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab2EJSSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:18:21 -0400
Date: Thu, 10 May 2012 11:18:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] ARM: tegra20: Add Tegra Memory Controller(MC) driver
Message-ID: <20120510181815.GA17018@kroah.com>
References: <1336635764-30597-1-git-send-email-hdoyu@nvidia.com>
 <4FABF9AB.6020902@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FABF9AB.6020902@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:23:55AM -0600, Stephen Warren wrote:
> On 05/10/2012 01:42 AM, Hiroshi DOYU wrote:
> > Tegra Memory Controller(MC) driver for Tegra20
> > Added to support MC General interrupts, mainly for IOMMU(GART).
> 
> Greg, you appear to have been commiting all of drivers/memory. I assume
> you'll take patches 1 and 3 in this series, and I will take 2 and 4
> through the Tegra tree? I can take them all through the Tegra tree if
> you want.

I think you will get a conflict if you take the memory ones in your
tree, so I will take those two, thanks.

greg k-h
