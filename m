Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2KBPAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:00:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45516 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2KBPAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:00:43 -0400
Message-ID: <5093E015.1070504@wwwdotorg.org>
Date: Fri, 02 Nov 2012 09:00:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Michal Marek <mmarek@suse.cz>, David Gibson <david@gibson.dropbear.id.au>,
        Jon Loeliger <jdl@jdl.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-arch@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-mips@linux-mips.org
Subject: Re: [PATCH V5 1/2] kbuild: centralize .dts->.dtb rule
References: <1351721431-26220-1-git-send-email-swarren@wwwdotorg.org> <20121102095801.GC17860@linux-mips.org> <20121102102335.GF2905@linux-mips.org>
In-Reply-To: <20121102102335.GF2905@linux-mips.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 04:23 AM, Ralf Baechle wrote:
> On Fri, Nov 02, 2012 at 10:58:01AM +0100, Ralf Baechle wrote:
> 
>> Can you fold these MIPS bits into your patch?
> 
> I missed Lantiq.

Thanks, I've squashed that in, and with a quick grep noticed that
arch/{arm64,microblaze} also need updating.
