Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0G0IKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:10:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0G0IKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:10:44 -0400
Message-ID: <4C4E9556.7050003@redhat.com>
Date: Tue, 27 Jul 2010 16:14:14 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: huang ying <huang.ying.caritas@gmail.com>, linux-kernel@vger.kernel.org,
        nhorman@redhat.com, akpm@linux-foundation.org
Subject: Re: [Patch] kexec: increase max of kexec segments and use dynamic
 allocation
References: <20100722061810.5659.87609.sendpatchset@localhost.localdomain>	<m1wrso2foi.fsf@fess.ebiederm.org> <4C47E7C9.60608@redhat.com>	<m1iq482duy.fsf@fess.ebiederm.org>	<AANLkTikZTGYl2NIFzcTCG2DAaMefhnJAkSHIoJN22QoI@mail.gmail.com>	<m1lj90p8yp.fsf@fess.ebiederm.org> <4C4D5F4F.8080002@redhat.com> <m1iq425tay.fsf@fess.ebiederm.org>
In-Reply-To: <m1iq425tay.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/10 20:19, Eric W. Biederman wrote:
> Cong Wang<amwang@redhat.com>  writes:
>
>> So, what is a better number? 2048? :)
>
> I was thinking something a little ridiculous like 10K or 64K.
>
> Assuming the usage you care about is something like hibernate on a
> machine with disjoint memory where you truly need one segment for
> each memory region.
>
> The only point of a limit at all once we introduce dynamic allocation
> is to catch buggy apps.
>

Ok, I will change that number and improve the changelog.

Thanks.


-- 
The opposite of love is not hate, it's indifference.
  - Elie Wiesel
