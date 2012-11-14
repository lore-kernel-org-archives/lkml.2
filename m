Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423523Ab2KNWZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:25:50 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42408 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423489Ab2KNWZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:25:49 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V6 2/2] kbuild: run the pre-processor on *.dts files
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, David Gibson <david@gibson.dropbear.id.au>,
        Jon Loeliger <jdl@jdl.com>, Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-arch@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
In-Reply-To: <50A3FC90.7030105@wwwdotorg.org>
References: <1352753907-3316-1-git-send-email-swarren@wwwdotorg.org> <1352753907-3316-2-git-send-email-swarren@wwwdotorg.org> <20121114192548.59F093E0B7C@localhost> <50A3FC90.7030105@wwwdotorg.org>
Date: Wed, 14 Nov 2012 22:25:45 +0000
Message-Id: <20121114222545.7E3943E0E2B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 13:18:24 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/14/2012 12:25 PM, Grant Likely wrote:
> > On Mon, 12 Nov 2012 13:58:27 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> >> From: Stephen Warren <swarren@nvidia.com>
> >>
> >> Modify cmd_dtc to run the C pre-processor on the input .dts file before
> >> passing it to dtc for final compilation. This allows the use of #define
> >> and #include within the .dts file.
> 
> > Ugh, I'm definitely nervous about turning this on because of the long
> > term implications so I'm going to punt on actually making a decision
> > about it for the momemnt. However, I do have a question...
> 
> Hmmm. So how do we get to a decision on this then?

I'm punting for the evening just because I'm mentally exhausted. I'll
make a decision in the next couple of days.

g.

