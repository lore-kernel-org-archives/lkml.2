Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1KRWDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:03:49 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44120 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1KRWDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:03:48 -0500
Message-ID: <4EC6D63F.8030207@gmail.com>
Date: Fri, 18 Nov 2011 16:03:43 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 01/10] arm/tegra: initial device tree for tegra30
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com> <1321546766-26770-2-git-send-email-pdeschrijver@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF1740D74C46@HQMAIL01.nvidia.com> <20111118184942.GA31678@quad.lixom.net> <4EC6B25D.70708@gmail.com> <CAOesGMhRQN2apJMQz7Fcp4-TnXYS6i30GLXOEckJG6kvPVatvw@mail.gmail.com>
In-Reply-To: <CAOesGMhRQN2apJMQz7Fcp4-TnXYS6i30GLXOEckJG6kvPVatvw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 03:48 PM, Olof Johansson wrote:
> On Fri, Nov 18, 2011 at 11:30 AM, Rob Herring <robherring2@gmail.com> wrote:
>> On 11/18/2011 12:49 PM, Olof Johansson wrote:
>>> On Thu, Nov 17, 2011 at 11:39:14AM -0800, Stephen Warren wrote:
>>>> Peter De Schrijver wrote at Thursday, November 17, 2011 9:19 AM:
>>>>> This patch adds the initial device tree for tegra30
>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/arm/tegra.txt
>>>> ...
>>>>> +* harmony: tegra20 based development board
>>>>> +Required root node properties:
>>>>> + - compatible = "nvidia,harmony", "nvidia,tegra20";
>>>>> +
>>>>> +* seaboard: tegra20 based clamshell reference design
>>>>> +Required root node properties:
>>>>> + - compatible = "nvidia,seaboard", "nvidia,tegra20";
>>>>
>>>> Do we really want to list all the board names here? In the future, there
>>>> could be tens or hundreds. I would argue that we should just document
>>>> nvidia,tegra20 and nvidia,tegra30.
>>>
>>> Agreed.
>>
>> It's not really any different than mach-types which does have every
>> board in it.
> 
> Yeah, and the whole idea of having device trees is to not have to do
> code changes when introducing a new derivative board. So enumerating
> all supported boards in the documentation means we're back to an
> equivalence to having to add machine ids.
> 
>> I think if a board requires a new dts, then it needs a unique name.
> 
> Sure, that's fine. But the idea is to be able to do it without
> changing code for many cases, just provide a new dts that configures
> the devices in question.

You can always claim backwards compatibility with any prior board that's
already supported. You may never need to do any more than that. You
don't want new kernels to require a new DTB if in fact you do have to
make code changes.

Rob

>>>> At a later point, we should fix board-dt.c to solely look for those
>>>> compatible values, although this will have to wait until the pinmux DT
>>>> bindings are present. Then, the kernel won't care about the board names.
>>>
>>> Exactly.
>>
>> That is perfectly acceptable, but you should still have the option to do
>> something specific for any given board.
> 
> Of course. That's not what we're objecting to here.
> 
> 
> -Olof

