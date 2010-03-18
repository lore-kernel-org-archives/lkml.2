Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0CRNYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:24:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab0CRNYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:24:19 -0400
Message-ID: <4BA2296A.90401@redhat.com>
Date: Thu, 18 Mar 2010 14:23:54 +0100
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
References: <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E7E2.3010803@redhat.com> <20100318095418.GD2157@elte.hu> <4BA2030B.3090007@redhat.com> <20100318105826.GA2174@elte.hu>
In-Reply-To: <20100318105826.GA2174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/10 11:58, Ingo Molnar wrote:
>
> * Jes Sorensen<Jes.Sorensen@redhat.com>  wrote:
>> Thats a very glorified statement but it's not reality, sorry. You can do
>> that with something like perf because it's so small and development of perf
>> is limited to a very small group of developers.
>
> I was not talking about just perf: i am also talking about the arch/x86/
> unification which is 200+ KLOC of highly non-trivial kernel code with hundreds
> of contributors and with 8000+ commits in the past two years.

Sorry but you cannot compare merging two chunks of kernel code that
originated from the same base, with the efforts of mixing a large
userland project with a kernel component. Apples and oranges.

> Also, it applies to perf as well: people said exactly that a year ago: 'perf
> has it easy to be clean as it is small, once it gets as large as Oprofile
> tooling it will be in the same messy situation'.
>
> Today perf has more features than Oprofile, has a larger and more complex code
> base, has more contributors, and no, it's not in the same messy situation at
> all.

Both perf and oprofile are still relatively small projects in comparison
to QEMU.

> So whatever you think of large, unified projects, you are quite clearly
> mistaken. I have done and maintained through two different types of
> unifications and the experience was very similar: both developers and users
> (and maintainers) are much better off.

You believe that I am wrong in my assessment of unified projects, and I
obviously think you are mistaken and underestimating the cost and
effects of trying to merge the two.

Well I think we are just going to agree to disagree on this one. I am
not against merging projects where it makes sense, but in this
particular case I am strongly convinced the loss would be much greater
than the gain.

Cheers,
Jes
