Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab0CROqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:46:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab0CROqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:46:51 -0400
Message-ID: <4BA23CA5.20801@redhat.com>
Date: Thu, 18 Mar 2010 15:45:57 +0100
From: Jes Sorensen <Jes.Sorensen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E7E2.3010803@redhat.com> <20100318095418.GD2157@elte.hu> <4BA2030B.3090007@redhat.com> <20100318105826.GA2174@elte.hu> <4BA2296A.90401@redhat.com> <20100318142255.GG25642@elte.hu>
In-Reply-To: <20100318142255.GG25642@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/10 15:22, Ingo Molnar wrote:
>
> * Jes Sorensen<Jes.Sorensen@redhat.com>  wrote:
>> Both perf and oprofile are still relatively small projects in comparison to
>> QEMU.
>
> So is your argument that the unification does not make sense due to size?
> Would a smaller Qemu be more appropriate for this purpose?

As I have stated repeatedly in this discussion, a unification would hurt
the QEMU development process because it would alienate a large number of
QEMU developers who are *not* Linux kernel users.

QEMU is a lot more complex than you let on.

>> Well I think we are just going to agree to disagree on this one. I am not
>> against merging projects where it makes sense, but in this particular case I
>> am strongly convinced the loss would be much greater than the gain.
>
> I wish you said that based on first hand negative experience with
> unifications, not based on just pure speculation.
>
> (and yes, i speculate too, but at least with some basis)

You still haven't given us a *single* example of unification of
something that wasn't purely linked to the Linux kernel. perf/
oprofile is 100% linked to the Linux kernel, QEMU is not. I wish
you would actually look at what users use QEMU for. As long as you
continue to purely speculate on this, to use your own words, your
arguments are not holding up.

And you are not being consistent either. You have conveniently
continue to ignore my questions about why the file system tools are not
to be merged into the Linux kernel source tree?

Jes
