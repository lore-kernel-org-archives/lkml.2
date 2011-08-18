Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1HRPIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 11:08:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab1HRPIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 11:08:50 -0400
Message-ID: <4E4D2AEC.8050601@redhat.com>
Date: Thu, 18 Aug 2011 08:08:28 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm tools: fix repeated io emulation
References: <4E4C81CE.8030508@cn.fujitsu.com>  <CAOJsxLEtQR3ue-suoC3akhGB=DwyoSofD_RuuNmz=A2jede22g@mail.gmail.com> <1313652951.28910.4.camel@lappy>
In-Reply-To: <1313652951.28910.4.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 12:35 AM, Sasha Levin wrote:
> On Thu, 2011-08-18 at 09:13 +0300, Pekka Enberg wrote:
> >  Hi,
> >
> >  On Thu, Aug 18, 2011 at 6:06 AM, Xiao Guangrong
> >  <xiaoguangrong@cn.fujitsu.com>  wrote:
> >  >  When kvm emulates repeation io read instruction, it can exit to user-space with
> >  >  'count'>  1, we need to emulate io access for many times
> >  >
> >  >  Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> >
> >  The KVM tool is not actually maintained by Avi and Marcelo but by me
> >  and few others. Our git repository is here:
> >
> >  https://github.com/penberg/linux-kvm
> >
> >  Ingo pulls that to -tip few times a week or so. Sasha, can you please
> >  take a look at these patches and if you're OK with them, I'll apply
> >  them.
>
> Pekka,
>
> I can only assume they're right, 'count' isn't documented anywhere :)
>
> If any of KVM maintainers could confirm it I'll add it into the docs.
>

Count is indeed the number of repetitions.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

