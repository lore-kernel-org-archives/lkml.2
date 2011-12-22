Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab1LVAOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:14:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:36882 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab1LVAOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:14:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="49577267"
Date: Wed, 21 Dec 2011 16:14:41 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        kay.sievers@vrf.org, kay.sievers@vrfy.org
Subject: Re: [PATCH 7/8] cpufreq: Add support for x86 cpuinfo auto loading
 v3
Message-ID: <20111222001441.GB10955@alboin.amr.corp.intel.com>
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org>
 <1324338394-4670-8-git-send-email-andi@firstfloor.org>
 <201112211203.26153.trenn@suse.de>
 <20111221201227.GA9262@alboin.amr.corp.intel.com>
 <4EF23E41.40608@zytor.com>
 <20111221213009.GA2568@redhat.com>
 <20111222000142.GA10955@alboin.amr.corp.intel.com>
 <4EF27517.6010609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF27517.6010609@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So this should be:
> 
> 1. added to the scattered CPUID features list;
> 2. artificially set in the AMD-specific initialization code for the
> older CPUs.

Not sure (2) is correct. As far as I understand it's actually different
mechanisms, just implemented by the same driver.

Keeping the list for old CPUs is not a big issue anyways.

Agreed with (1)

Anyways someone with the hardware should do it. Thomas?

-Andi
