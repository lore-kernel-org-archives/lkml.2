Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab2EHQP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:15:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56853 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab2EHQPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:15:55 -0400
Message-ID: <4FA946B7.2020302@wwwdotorg.org>
Date: Tue, 08 May 2012 10:15:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Rhyland Klein <rklein@nvidia.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 6/6 v3] ARM: Tegra: Add support for TPS65910 PMIC
References: <1336502563-31789-1-git-send-email-rklein@nvidia.com> <1336502563-31789-7-git-send-email-rklein@nvidia.com> <4FA94212.4000207@wwwdotorg.org> <20120508155847.GC15893@opensource.wolfsonmicro.com>
In-Reply-To: <20120508155847.GC15893@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 09:58 AM, Mark Brown wrote:
> On Tue, May 08, 2012 at 09:56:02AM -0600, Stephen Warren wrote:
>> On 05/08/2012 12:42 PM, Rhyland Klein wrote:
>>> Add support for the tps65910 pmic on cardhu.
> 
>> Lets ignore this one patch for now; it's not clear whether Cardhu
>> should instantiate the TPS65910 or TPS62360 PMU; apparently
>> different Cardhu variants have one, the other, or even both. I'm
>> trying to find out which variant(s) is/are useful to support.
> 
> IIRC it's the same as Whistler was and even more fun that that -
> you might have random PMIC boards appearing from random places and
> can't rely on what's on the system at all!  See the thread I
> started about plugin modules the other day :)

I think you're thinking of some other board. Cardhu is a tablet
reference platform without pluggable modules, and I believe the PMIC
mess is just due to some rework in later board revisions to solve some
under-power issues in the earlier variants. But I believe there is
some Tegra30 reference board equivalent to Whistler with all kinds of
pluggable modules, although I haven't touched one yet, and don't
recall its name.
