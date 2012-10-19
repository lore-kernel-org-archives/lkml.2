Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab2JSP4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:56:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48226 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab2JSP4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:56:19 -0400
Message-ID: <50817820.6010301@wwwdotorg.org>
Date: Fri, 19 Oct 2012 09:56:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Vinod Koul <vinod.koul@linux.intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] ARM: tegra: dts: add slink controller dt entry
References: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com> <1350557795-31487-3-git-send-email-ldewangan@nvidia.com> <50808595.8070505@wwwdotorg.org> <5081190D.50200@nvidia.com>
In-Reply-To: <5081190D.50200@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 03:10 AM, Laxman Dewangan wrote:
> On Friday 19 October 2012 04:11 AM, Stephen Warren wrote:
>> On 10/18/2012 04:56 AM, Laxman Dewangan wrote:
>>> Add slink controller details in the dts file of
>>> Tegra20 and Tegra30.
>>> diff --git a/arch/arm/boot/dts/tegra20.dtsi
>>> b/arch/arm/boot/dts/tegra20.dtsi
>>> +    slink@7000d400 {
>>> +        compatible = "nvidia,tegra20-slink";
>>> +        reg =<0x7000d400 0x200>;
>>> +        interrupts =<0 59 0x04>;
>>> +        nvidia,dma-req-sel =<15>;
>

(Oh, you need a space before and after the = in all the lines above)

>> I thought the common DT DMA bindings were going to be in 3.7, and hence
>> we could just use them here rather than inventing another custom
>> property for this purpose?
>
> Adding Vinod here.
> 
> I looked the dma devicetree bingind document and did not found the
> generic binding name. Howvere, for arm-pl330.txt, it is explained as ...

That's not the generic bindings. I guess they didn't get merged then. I
guess we can continue with custom bindings until they are.
