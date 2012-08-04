Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2HDAwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 20:52:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51504 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062Ab2HDAwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 20:52:38 -0400
Date: Sat, 4 Aug 2012 01:52:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, sameo@linux.intel.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] regulator: tps6586x: add support for SYS rail
Message-ID: <20120804005234.GH4515@opensource.wolfsonmicro.com>
References: <1343906193-8309-1-git-send-email-ldewangan@nvidia.com>
 <501AAE55.3080504@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501AAE55.3080504@wwwdotorg.org>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 10:44:05AM -0600, Stephen Warren wrote:
> On 08/02/2012 05:16 AM, Laxman Dewangan wrote:

> >         .desc   = {                                                     \
> > +               .supply_name = "sys",                                   \
> >                 .name   = "REG-SYS",                                    \
> >                 .ops    = &tps6586x_sys_regulator_ops,                  \
> >                 .type   = REGULATOR_VOLTAGE,                            \

> BTW, this patch touches both the regulator and MFD trees. I'm not sure
> who will apply it. I think it relies on the patch to this driver Mark
> recently applied in the regulator tree (for 3.7 I think) doesn't it, at
> least for context?

It varies - it's usually whichever tree the change logically belongs in
(so adding a define for a new regulator in the MFD would go with the
rest of the implementation of a new regulator but a change in the
register I/O interface of the core would go via MFD).
