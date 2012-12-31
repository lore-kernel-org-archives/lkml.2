Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab2LaRYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 12:24:13 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:36353 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2LaRYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 12:24:11 -0500
Message-ID: <50E1CA34.8010305@gmail.com>
Date: Mon, 31 Dec 2012 11:24:04 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: dts: prevent *.dtb from always being rebuilt
References: <1356741767-29292-1-git-send-email-swarren@wwwdotorg.org> <20121230053204.GC20903@quad.lixom.net> <50E1BFA6.9040102@wwwdotorg.org>
In-Reply-To: <50E1BFA6.9040102@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2012 10:39 AM, Stephen Warren wrote:
> On 12/29/2012 10:32 PM, Olof Johansson wrote:
>> On Fri, Dec 28, 2012 at 05:42:46PM -0700, Stephen Warren wrote:
>>> From: Stephen Warren <swarren@nvidia.com>
>>>
>>> if_changed (used by the *.dts->*.dtc rule) rebuilds files if they aren't
>>> contained in $(targets). (make V=2 indicates this). Add $(dtb-y) to
>>> $(targets) to prevent *.dtb from always being rebuilt.
>>>
>>> This fixes a regression introduced by the .dtb rule rework in 499cd82
>>> "ARM: dt: change .dtb build rules to build in dts directory".
>>>
>>> Reported-by: Shawn Guo <shawn.guo@linaro.org>
>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>
>> Not sure who you have in mind to apply this, but if it's not through arm-soc:
>>
>> Acked-by: Olof Johansson <olof@lixom.net>
> 
> I was assuming through the device tree tree, since that's where the dtc
> rule rework went through, but I think it's mostly just about whoever
> picks it up:-)
> 

I'll pick up both.

Rob

