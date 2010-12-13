Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0LMJJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 04:09:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab0LMJJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 04:09:03 -0500
Message-ID: <4D05E2A5.8070204@redhat.com>
Date: Mon, 13 Dec 2010 11:08:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mst@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [104/223] KVM: Write protect memory after slot swap
References: <201012131244.547034648@firstfloor.org>    <20101212234644.B05DAB27BF@basil.firstfloor.org>    <4D05DC98.40105@redhat.com>    <044a861a2279c7e3e328c73e6694fbf3.squirrel@www.firstfloor.org>    <4D05E096.6060307@redhat.com> <74ff92a8c4cf72e42e7559de72e77b52.squirrel@www.firstfloor.org>
In-Reply-To: <74ff92a8c4cf72e42e7559de72e77b52.squirrel@www.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 11:03 AM, Andi Kleen wrote:
> >  On 12/13/2010 10:58 AM, Andi Kleen wrote:
> >>  >   On 12/13/2010 01:46 AM, Andi Kleen wrote:
> >>  >>   2.6.35-longterm review patch.  If anyone has any objections, please
> >>  let
> >>  >>   me know.
> >>  >>
> >>  >
> >>  >   The way kvm stable updates work, Marcelo and I collect the patches,
> >>  >   autotest them, and submit them to the stable maintainers.  This way
> >>  the
> >>  >   first stable users don't get to be the first ones to actually test
> >>  the
> >>  >   new fixes.
> >>
> >>  This should be the (nearly) end point of this process for 2.6.35.
> >
> >  Sorry, I don't follow.  Please elaborate.
>
> People submit the patches to stable@kernel.org
> Greg collects them for his stable and long term kernels.
> I pick them up them for 2.6.35-longterm. Others for their longterm
> kernels.
>
> Then after some time the collected patches get posted for the 48hour
> review period, as described in the stable rules. That is what you
> saw here. After that they get released.
>
> If you have any objections to this particular patch please let me
> know.

I don't have an objection to the patch, rather to the methodology where 
stable kernels are more or less totally untested.  I would like at least 
the kvm part to see some testing before it sees users.  The process we 
worked out with Greg is:

- Greg rejects kvm patches (but not virtio etc) pointing submitters to 
the kvm maintainers
- The kvm maintainers collect stable kvm patches and autotest them
- They then submit the patches to stable@

The process is slower than the standard stable process but results in 
something that is less likely to fail.

-- 
error compiling committee.c: too many arguments to function

