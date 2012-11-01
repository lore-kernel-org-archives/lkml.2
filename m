Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273Ab2KAUb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:31:27 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:24982 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab2KAUbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:31:20 -0400
Date: Thu, 1 Nov 2012 21:31:18 +0100
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
Subject: Re: [PATCH V5 2/2] kbuild: run the pre-processor on *.dts files
Message-ID: <20121101203118.GC6439@merkur.ravnborg.org>
References: <1351721431-26220-1-git-send-email-swarren@wwwdotorg.org> <1351721431-26220-2-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351721431-26220-2-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 04:10:31PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Modify cmd_dtc to run the C pre-processor on the input .dts file before
> passing it to dtc for final compilation. This allows the use of #define
> and #include within the .dts file.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
