Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2JDStZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:49:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17253 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2JDStW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:49:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6855"; a="243549937"
Message-ID: <506DDA31.9010503@codeaurora.org>
Date: Thu, 04 Oct 2012 11:49:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: arm@kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: arm-soc maintainer entry
References: <506D4BCD.3020402@codeaurora.org> <CAOesGMjotnx_6HiwngRO9OaZYGGAexiwZ_shkOK7qROZcjDmqA@mail.gmail.com>
In-Reply-To: <CAOesGMjotnx_6HiwngRO9OaZYGGAexiwZ_shkOK7qROZcjDmqA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/12 09:55, Olof Johansson wrote:
> Hi,
>
> On Thu, Oct 4, 2012 at 1:41 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> Is the arm@kernel.org alias going to be added into the MAINTAINERS file?
>> Should anybody be sending mails to this address?
>>
>> It seems I asked this over a year ago and the response was positive but
>> nothing ever happened[1]. Maybe something like below? I only ask because
>> get_maintainer.pl isn't picking up this email.
> I've been holding off re-proposing this, mostly because life is easier
> for us if we don't get arm@kernel.org cc:d on every single patch by
> people who run get_maintainers.pl -- it's the equivalent of getting
> linux-arm-kernel cc:d to your inbox. It's better signal-to-noise ratio
> if it's mostly platform maintainers that email us on that address with
> pull requests or patches they want applied.
>
> But yeah, it also means that the maintainer structure is undocumented.
> I'm open for suggestions.
>

Thanks for clarifying. Maybe we can put in the git tree and no email
address? That at least documents some structure.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

