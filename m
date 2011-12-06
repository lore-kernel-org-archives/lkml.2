Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1LFWOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:14:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35990 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab1LFWON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:14:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6552"; a="141990213"
Message-ID: <4EDE9289.8040903@codeaurora.org>
Date: Tue, 06 Dec 2011 14:09:13 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Introducing a generic AMP framework
References: <1319536106-25802-1-git-send-email-ohad@wizery.com> <4ECC67B9.4050306@codeaurora.org> <CAK=WgbYyrbZLmDOx8yKWwjhn2MYN8669FDRvsYZSyLj1equcTw@mail.gmail.com> <20111123161012.GA31423@sirena.org.uk> <4ECD5767.90307@codeaurora.org> <CAK=Wgba49eu_MGTWP_SND1=KDPp=MfuDyvxFGA_NND=ydqBmZA@mail.gmail.com>
In-Reply-To: <CAK=Wgba49eu_MGTWP_SND1=KDPp=MfuDyvxFGA_NND=ydqBmZA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 12:43 AM, Ohad Ben-Cohen wrote:
> On Wed, Nov 23, 2011 at 10:28 PM, Saravana Kannan
> <skannan@codeaurora.org>  wrote:
>> remoteproc would probably be the best fit since it's already used in the
>> code and people are used to discussing about it.
>
> Guys you realize that 'amp' isn't really being used in the code
> itself; this discussion boils down to the text we have in the patches'
> subject line and the top level Kconfig/folder entry :)
>
> But, sure, I'll just drop those 'amp' text instances, and we'll have
> 'remoteproc' and 'rpmsg' as separate top-level frameworks again.
>
> Thanks,
> Ohad.

Yes, I did realize it's not used in the code. I just wanted to prevent 
what I considered a misuse of "AMP". Thanks for accommodating my request.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
