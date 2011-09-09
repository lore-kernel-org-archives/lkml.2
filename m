Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab1IICYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 22:24:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55087 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932548Ab1IICYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 22:24:01 -0400
Message-ID: <4E69794F.9010008@cn.fujitsu.com>
Date: Fri, 09 Sep 2011 10:26:23 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm tools: fix repeated io emulation
References: <4E4C81CE.8030508@cn.fujitsu.com>  <CAOJsxLEtQR3ue-suoC3akhGB=DwyoSofD_RuuNmz=A2jede22g@mail.gmail.com> <1313652951.28910.4.camel@lappy> <4E4D2AEC.8050601@redhat.com>
In-Reply-To: <4E4D2AEC.8050601@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-09 10:22:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-09 10:22:53,
	Serialize complete at 2011-09-09 10:22:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 11:08 PM, Avi Kivity wrote:
> On 08/18/2011 12:35 AM, Sasha Levin wrote:
>> On Thu, 2011-08-18 at 09:13 +0300, Pekka Enberg wrote:
>> >  Hi,
>> >
>> >  On Thu, Aug 18, 2011 at 6:06 AM, Xiao Guangrong
>> >  <xiaoguangrong@cn.fujitsu.com>  wrote:
>> >  >  When kvm emulates repeation io read instruction, it can exit to user-space with
>> >  >  'count'>  1, we need to emulate io access for many times
>> >  >
>> >  >  Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
>> >
>> >  The KVM tool is not actually maintained by Avi and Marcelo but by me
>> >  and few others. Our git repository is here:
>> >
>> >  https://github.com/penberg/linux-kvm
>> >
>> >  Ingo pulls that to -tip few times a week or so. Sasha, can you please
>> >  take a look at these patches and if you're OK with them, I'll apply
>> >  them.
>>
>> Pekka,
>>
>> I can only assume they're right, 'count' isn't documented anywhere :)
>>
>> If any of KVM maintainers could confirm it I'll add it into the docs.
>>
> 
> Count is indeed the number of repetitions.
> 

Hi Pekka,

Could you pick up this patchset please?

