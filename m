Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab2EHP4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:56:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36863 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab2EHP4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:56:05 -0400
Message-ID: <4FA94212.4000207@wwwdotorg.org>
Date: Tue, 08 May 2012 09:56:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 6/6 v3] ARM: Tegra: Add support for TPS65910 PMIC
References: <1336502563-31789-1-git-send-email-rklein@nvidia.com> <1336502563-31789-7-git-send-email-rklein@nvidia.com>
In-Reply-To: <1336502563-31789-7-git-send-email-rklein@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 12:42 PM, Rhyland Klein wrote:
> Add support for the tps65910 pmic on cardhu.

Lets ignore this one patch for now; it's not clear whether Cardhu should
instantiate the TPS65910 or TPS62360 PMU; apparently different Cardhu
variants have one, the other, or even both. I'm trying to find out which
variant(s) is/are useful to support.

But this has no effect on the other patches in this series.
