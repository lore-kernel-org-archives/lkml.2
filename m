Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab0ELJQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:16:18 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:40316 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab0ELJQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:16:16 -0400
Message-ID: <4BEA72B0.4010105@oss.ntt.co.jp>
Date: Wed, 12 May 2010 18:19:44 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, avi@redhat.com,
       mtosatti@redhat.com, fernando@oss.ntt.co.jp, kvm@vger.kernel.org,
       kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/12] KVM, x86, ppc, asm-generic: moving dirty bitmaps
 to user space
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com> <4BE97DFA.1060408@suse.de>
In-Reply-To: <4BE97DFA.1060408@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> [To ppc people]
>>
>> Hi, Benjamin, Paul, Alex,
>>
>> Please see the patches 6,7/12. I first say sorry for that I've not tested these
>> yet. In that sense, these may not be in the quality for precise reviews. But I
>> will be happy if you would give me any comments.
>>
>> Alex, could you help me? Though I have a plan to get PPC box in the future,
>> currently I cannot test these.
>>
>
> Could you please point me to a git tree where everything's readily
> applied? That would make testing a lot easier.

OK, I'll prepare one. Probably on sourceforge or somewhere like Kemari.

Thanks,
   Takuya


>
> Alex
>

