Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab2J1HYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 03:24:42 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:24336 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2J1HYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 03:24:40 -0400
Date: Sun, 28 Oct 2012 08:24:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V4 REPOST 1/2] kbuild: centralize .dts->.dtb rule
Message-ID: <20121028072438.GA3879@merkur.ravnborg.org>
References: <1351279797-16450-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351279797-16450-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:29:56PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> All architectures that use cmd_dtc do so in the same way. Move the build
> rule to a central location to avoid duplication.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

This is missing documentation of the new rule in Documentation/kbuild/makefiles.txt

	Sam
