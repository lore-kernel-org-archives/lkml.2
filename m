Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1KVIpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:45:15 -0500
Received: from metasoft.pl ([195.149.224.191]:49841 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab1KVIpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:45:14 -0500
X-clamdmail: clamdmail 0.18a
Message-ID: <4ECB610F.7020904@metasoft.pl>
Date: Tue, 22 Nov 2011 09:45:03 +0100
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: linux-arm-kernel@lists.infradead.org, rmallon@gmail.com,
        vinod.koul@intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        hsweeten@visionengravers.com, dan.j.williams@intel.com, lrg@ti.com
Subject: Re: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
References: <cover.1306662317.git.mika.westerberg@iki.fi> <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi> <4EC27EED.4030108@metasoft.pl> <20111116065512.GB2703@mwesterb-mobl.ger.corp.intel.com> <4EC374F0.8000400@metasoft.pl> <20111119123837.GA2711@mwesterb-mobl.ger.corp.intel.com> <4ECA0147.4020806@metasoft.pl> <20111121080158.GA2713@mwesterb-mobl.ger.corp.intel.com> <4ECA11C5.802@metasoft.pl> <20111122064727.GB15889@mwesterb-mobl.ger.corp.intel.com>
In-Reply-To: <20111122064727.GB15889@mwesterb-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-22 07:47, Mika Westerberg wrote:
> Let me know if this works for you. Basically it's the patch from you except
> that we use a flag to indicate if the channel is running or not.
> 

It works correctly. All of my simple hdd tests completed without any problems.
Thanks.
