Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab0LMJTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 04:19:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab0LMJTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 04:19:31 -0500
Message-ID: <4D05E518.6040906@redhat.com>
Date: Mon, 13 Dec 2010 11:19:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, mst@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [104/223] KVM: Write protect memory after slot swap
References: <201012131244.547034648@firstfloor.org> <20101212234644.B05DAB27BF@basil.firstfloor.org> <4D05DC98.40105@redhat.com> <044a861a2279c7e3e328c73e6694fbf3.squirrel@www.firstfloor.org> <4D05E096.6060307@redhat.com> <74ff92a8c4cf72e42e7559de72e77b52.squirrel@www.firstfloor.org> <4D05E2A5.8070204@redhat.com> <AANLkTikcYAaxrdRR_i3p5o2tegEVM=0ajuihwu+C5eoK@mail.gmail.com>
In-Reply-To: <AANLkTikcYAaxrdRR_i3p5o2tegEVM=0ajuihwu+C5eoK@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 11:13 AM, Paolo Ciarrocchi wrote:
> On Mon, Dec 13, 2010 at 10:08 AM, Avi Kivity<avi@redhat.com>  wrote:
> >  I don't have an objection to the patch, rather to the methodology where
> >  stable kernels are more or less totally untested.  I would like at least the
> >  kvm part to see some testing before it sees users.  The process we worked
> >  out with Greg is:
> >
> >  - Greg rejects kvm patches (but not virtio etc) pointing submitters to the
> >  kvm maintainers
> >  - The kvm maintainers collect stable kvm patches and autotest them
> >  - They then submit the patches to stable@
> >
> >  The process is slower than the standard stable process but results in
> >  something that is less likely to fail.
>
> But all the patches tagged for -stable are supposed to be already
> upstream and therefore well tested.
> What am I missing?

They were tested upstream on the upstream code base.  That says nothing 
about 2.6.35 (well, it says something, but not as much as "2.6.35 with 
the patch managed to install and run various tests with several Linux 
and Windows guests, and did not cause regressions in the unit test suite").

-- 
error compiling committee.c: too many arguments to function

