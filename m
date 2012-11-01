Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936029Ab2KAUa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:30:56 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:62259 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab2KAUat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:30:49 -0400
Date: Thu, 1 Nov 2012 21:30:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, David Gibson <david@gibson.dropbear.id.au>,
        Jon Loeliger <jdl@jdl.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V5 1/2] kbuild: centralize .dts->.dtb rule
Message-ID: <20121101203047.GB6439@merkur.ravnborg.org>
References: <1351721431-26220-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351721431-26220-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 04:10:30PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> All architectures that use cmd_dtc do so in the same way. Move the build
> rule to a central location to avoid duplication.
> 
> Update Documentation/kbuild to remove the explicit call to cmd_dtc from
> the example, now that the rule exists in a centralized location, and in
> fact replace the example with a couple that still exist.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

