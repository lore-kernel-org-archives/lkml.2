Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab2LaQjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 11:39:09 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54934 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab2LaQjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 11:39:05 -0500
Message-ID: <50E1BFA6.9040102@wwwdotorg.org>
Date: Mon, 31 Dec 2012 09:39:02 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 1/2] ARM: dts: prevent *.dtb from always being rebuilt
References: <1356741767-29292-1-git-send-email-swarren@wwwdotorg.org> <20121230053204.GC20903@quad.lixom.net>
In-Reply-To: <20121230053204.GC20903@quad.lixom.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2012 10:32 PM, Olof Johansson wrote:
> On Fri, Dec 28, 2012 at 05:42:46PM -0700, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> if_changed (used by the *.dts->*.dtc rule) rebuilds files if they aren't
>> contained in $(targets). (make V=2 indicates this). Add $(dtb-y) to
>> $(targets) to prevent *.dtb from always being rebuilt.
>>
>> This fixes a regression introduced by the .dtb rule rework in 499cd82
>> "ARM: dt: change .dtb build rules to build in dts directory".
>>
>> Reported-by: Shawn Guo <shawn.guo@linaro.org>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> Not sure who you have in mind to apply this, but if it's not through arm-soc:
> 
> Acked-by: Olof Johansson <olof@lixom.net>

I was assuming through the device tree tree, since that's where the dtc
rule rework went through, but I think it's mostly just about whoever
picks it up:-)
