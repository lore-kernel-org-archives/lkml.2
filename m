Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2JAPgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:36:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46910 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2JAPgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:36:15 -0400
Message-ID: <5069B86A.2060100@wwwdotorg.org>
Date: Mon, 01 Oct 2012 09:36:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: David Gibson <david@gibson.dropbear.id.au>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [RFC PATCH 1/2] kbuild: centralize .dts->.dtb rule
References: <1348860731-20868-1-git-send-email-swarren@wwwdotorg.org> <1348860731-20868-2-git-send-email-swarren@wwwdotorg.org> <20120929200828.GD31527@game.jcrosoft.org>
In-Reply-To: <20120929200828.GD31527@game.jcrosoft.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2012 02:08 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 13:32 Fri 28 Sep     , Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> All architectures that use cmd_dtc do so in the same way. Move the build
>> rule to a central location to avoid duplication.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> Jean-Christophe,
>> Moving the build rule to Makefile.lib rather than Makefile.build seems
>> reasonable to me; the dtc-related logic is already in Makefile.lib, and
>> for features where cmd_* is defined in Makefile.lib, the associated
>> build rule is also defined there. I see no reason for this patch series
>> to move all the dtc-related logic into Makefile.build.
> 
> build rules are in Makefile.build c to o , s to o etc...

As I explicitly pointed out above, your statement is simply not true;
there are many build rules in Makefile.lib.

> so put it in Makefile.build is the correct place ditto fot the dtc cmd

As such, I'm just going to ignore that feedback. Perhaps the kbuild
maintainer (oops, who I forgot to CC; I'll forward him the patches) can
weigh in though.
