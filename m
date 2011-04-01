Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab1DAVyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:54:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23889 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab1DAVyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:54:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6303"; a="83520468"
Message-ID: <4D96499B.5070402@codeaurora.org>
Date: Fri, 01 Apr 2011 14:54:35 -0700
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Neil Leeder <nleeder@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        Sheetal Sahasrabudhe <sheetals@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, jamie.iles@picochip.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: accessing vfpinstr macros from outside vfp directory
References: <4D924966.2050707@codeaurora.org> <1301678843.17592.5.camel@e102144-lin.cambridge.arm.com>
In-Reply-To: <1301678843.17592.5.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/11 10:27, Will Deacon wrote:
> Neil,
> 
> On Tue, 2011-03-29 at 22:04 +0100, Neil Leeder wrote:
>> Any opinions on what would be the best thing to do here? Choices appear to be:
>>
>> 1) allow the relative include path of ../vfp/vfpinstr.h
>> 2) move the definitions of fmrx, fmxr from vfp/vfpinstr.h to include/asm/vfp.h
>> 3) move vfp/vfpinstr.h to include/asm
>> 4) other...?
>>
>> If it helps, I can create a patch for whichever is considered the preferred solution.
>>
> 
> I personally don't find option (1) that offensive - Bryan seemed to
> differ though so perhaps option (2) would keep him happy?
> 
> I don't think option (3) is sensible given that the majority of the
> header file is private to /vfp.
> 
> Will

I raised it as a question.  If that's the only sane thing to do here,
then do it.  Since no one else seems to have chimed in on (2) or (3),
I'm fine with the patch as-is.

- Bryan

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
