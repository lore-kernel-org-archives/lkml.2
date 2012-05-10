Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab2EJWid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:38:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42114 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761578Ab2EJWia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:38:30 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] iommu/tegra: smmu: Add device tree support for SMMU
To: Stephen Warren <swarren@wwwdotorg.org>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-tegra@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Ohad Ben-Cohen <ohad@wizery.com>,
        Tony Lindgren <tony@atomide.com>, Jiri Kosina <jkosina@suse.cz>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4FAC2041.7030405@wwwdotorg.org>
References: <1336636221-31575-1-git-send-email-hdoyu@nvidia.com> <1336636221-31575-2-git-send-email-hdoyu@nvidia.com> <4FAC2041.7030405@wwwdotorg.org>
Date: Thu, 10 May 2012 16:38:27 -0600
Message-Id: <20120510223828.091203E04A6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 14:08:33 -0600, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/10/2012 01:50 AM, Hiroshi DOYU wrote:
> > The necessary info is expected to pass from DT.
> > 
> > For more precise resource reservation, there shouldn't be any
> > overlapping of register range between SMMU and MC. SMMU register
> > offset needs to be calculated correctly, based on its register bank.
> > 
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.

