Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab2C2PuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 11:50:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35704 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab2C2Ptw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 11:49:52 -0400
Message-ID: <4F74849C.4090907@wwwdotorg.org>
Date: Thu, 29 Mar 2012 09:49:48 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Shridhar Rasal <srasal@nvidia.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        Rakesh Iyer <riyer@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/1] input: keyboard: Set configuration registers
References: <1323415758-16822-1-git-send-email-srasal@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF1751860550@HQMAIL01.nvidia.com> <3849551.l2KNPKMSmh@dtor-d630.eng.vmware.com> <74CDBE0F657A3D45AFBB94109FB122FF17518605E5@HQMAIL01.nvidia.com> <20111230032559.GB17850@core.coreip.homeip.net> <20120131190904.GA20672@core.coreip.homeip.net> <74CDBE0F657A3D45AFBB94109FB122FF178E1244A2@HQMAIL01.nvidia.com> <20120131194735.GA22872@core.coreip.homeip.net> <4F714D5C.1050400@nvidia.com> <4F71DB3E.4090606@wwwdotorg.org>
In-Reply-To: <4F71DB3E.4090606@wwwdotorg.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2012 09:22 AM, Stephen Warren wrote:
> On 03/26/2012 11:17 PM, Shridhar Rasal wrote:
>> On 02/01/2012 01:17 AM, Dmitry Torokhov wrote:
>>> On Tue, Jan 31, 2012 at 11:29:35AM -0800, Stephen Warren wrote:
...
>>>> I'd rather PIN_CFG_IGNORE was the first enum, so it gets value 0, or
>>>> this probably won't solve the original issue?
>>>
>>> The benefit of current definition is that it is compatible with old
>>> ones using bool...
>>>
>>> Thanks.
>>
>> Sorry for delay in response.
>> I am OK with new definition. Agree, makes compatible with old definitions.
>> Thanks!
> 
> Which new definition; the one in Dmitry's patch, or what I proposed
> above? Note that from what I recall, Dmitry's patch doesn't solve the
> problem.

Nevermind, I see this patch has been modified to address my concerns,
and already applied.
