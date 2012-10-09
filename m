Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab2JIVQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:16:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33214 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab2JIVQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:16:52 -0400
Message-ID: <50749441.8030307@wwwdotorg.org>
Date: Tue, 09 Oct 2012 15:16:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jon Loeliger <jdl@jdl.com>
CC: Rob Herring <robherring2@gmail.com>, Michal Marek <mmarek@suse.cz>,
        David Gibson <david@gibson.dropbear.id.au>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: dtc: import latest upstream dtc
References: <1348867559-2495-1-git-send-email-swarren@wwwdotorg.org> <5069C042.40209@gmail.com> <5069C11C.6040505@wwwdotorg.org> <5069D946.1060502@gmail.com> <5069E1F0.5070902@wwwdotorg.org> <E1TIktZ-0000U4-Qh@jdl.com>
In-Reply-To: <E1TIktZ-0000U4-Qh@jdl.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 12:39 PM, Jon Loeliger wrote:
>>
>> What more do you think needs discussion re: dtc+cpp?
> 
> How not to abuse the ever-loving shit out of it? :-)

Perhaps we can just handle this through the regular patch review
process; I think it may be difficult to define and agree upon exactly
what "abuse" means ahead of time, but it's probably going to be easy
enough to recognize it when one sees it?

I imagine the most common usage will simply be a bunch of:

#define TEGRA_GPIO_PB0 32
#define TEGRA_GPIO_INT_LEVEL_LOW 8

/ {
    xxx {
        interrupts = <TEGRA_GPIO_PB0 TEGRA_GPIO_INT_LEVEL_LOW>;

and similarly, simple math:

    something = <((FOO << XXX_SHIFT) | (BAR << YYY_SHIFT))>;

