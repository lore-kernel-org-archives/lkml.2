Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab1FUUgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:36:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6533 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab1FUUgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:36:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6384"; a="99184497"
Message-ID: <4E0100BF.6080500@codeaurora.org>
Date: Tue, 21 Jun 2011 13:36:15 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Subject: Re: [RFC] Add Arm cpu topology definition
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>	<4DFA5C2E.40507@codeaurora.org> <BANLkTi=ik=iRtDb3K__CPxSH_8GusoBHKA@mail.gmail.com>
In-Reply-To: <BANLkTi=ik=iRtDb3K__CPxSH_8GusoBHKA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 11:54 PM, Vincent Guittot wrote:
> On 16 June 2011 21:40, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> The ARM ARM says these fields are IMPLEMENTATION DEFINED meaning that
>> different vendors may attribute different meaning to these fields if
>> they wish. Does that mean this should be a platform_*() function?
>>
> The ARM ARM also provides a recommended use of the fields of this
> register and the TRM of each Cortex adds some details. On the cortex
> A9, each platform can only set the value of the Cluster ID with the
> CLUSTERID pins. I have tried to consolidate the value of MPIDR  across
> several platforms and they all match with the description.
>
> Have you got an example of a MPIDR register which doesn't match with
> the implementation ?

Not that I know of. I'm more concerned with how the ARM ARM has two
recommended usages for these fields depending on virtualization or not.
I suppose we can handle that issue when it arises (or does your
implementation already handle that?)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

