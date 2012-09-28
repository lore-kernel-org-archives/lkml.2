Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423296Ab2I1V1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:27:43 -0400
Received: from jdl.com ([208.123.74.7]:58684 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423266Ab2I1V1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:27:40 -0400
X-Greylist: delayed 2845 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 17:27:40 EDT
Message-Id: <E1THhLo-00073d-FY@jdl.com>
To: Stephen Warren <swarren@wwwdotorg.org>
cc: David Gibson <david@gibson.dropbear.id.au>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [RFC PATCH 0/2] dtc: enable use of pre-processor
In-reply-to: <1348860731-20868-1-git-send-email-swarren@wwwdotorg.org>
References: <1348860731-20868-1-git-send-email-swarren@wwwdotorg.org>
Comments: In-reply-to Stephen Warren <swarren@wwwdotorg.org>
   message dated "Fri, 28 Sep 2012 13:32:09 -0600."
Date: Fri, 28 Sep 2012 15:39:56 -0500
From: Jon Loeliger <jdl@jdl.com>
X-Spam-Score: -0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stephen Warren <swarren@nvidia.com>
> 
> I'll post a patch to update the in-kernel dtc to the upstream dtc as
> soon as one final dtc patch has been applied, and this series will then
> depend on that patch.

And that patch, I think, has just been applied to the 
upstream DTC repo at git.jdl.com:

    commit 317a5d92bc357aba2c993ee78b4c089b7539fcc6
    Author: Stephen Warren <swarren@nvidia.com>
    Date:   Fri Sep 28 12:39:22 2012 -0600

    dtc: zero out new label objects
    
    Without this, new->deleted may be left set to some random value, which
    may then cause future label references to fail to locate the label. The
    code that allocates properties and nodes already contains the equivalent
    memset().
    
    Signed-off-by: Stephen Warren <swarren@nvidia.com>

HTH,
jdl
