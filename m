Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0LMRIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:08:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0LMRIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:08:43 -0500
Message-ID: <4D0652FB.2090208@redhat.com>
Date: Mon, 13 Dec 2010 19:08:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Andi Kleen <andi@firstfloor.org>, mst@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [104/223] KVM: Write protect memory after slot swap
References: <201012131244.547034648@firstfloor.org>	<20101212234644.B05DAB27BF@basil.firstfloor.org>	<4D05DC98.40105@redhat.com>	<044a861a2279c7e3e328c73e6694fbf3.squirrel@www.firstfloor.org>	<4D05E096.6060307@redhat.com>	<74ff92a8c4cf72e42e7559de72e77b52.squirrel@www.firstfloor.org>	<4D05E2A5.8070204@redhat.com>	<20101213091254.GA999@basil.fritz.box>	<4D05E483.1000106@redhat.com> <AANLkTinOWHcyjXsY3Xhe6pxi3gyQ3tJMr2qCpRPuyBW4@mail.gmail.com>
In-Reply-To: <AANLkTinOWHcyjXsY3Xhe6pxi3gyQ3tJMr2qCpRPuyBW4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 06:56 PM, Paul Gortmaker wrote:
> On Mon, Dec 13, 2010 at 4:16 AM, Avi Kivity<avi@redhat.com>  wrote:
> >  On 12/13/2010 11:12 AM, Andi Kleen wrote:
> >>
> >>  >    - Greg rejects kvm patches (but not virtio etc) pointing submitters
> >>  >    to the kvm maintainers
> >>  >    - The kvm maintainers collect stable kvm patches and autotest them
> >>
> >>  As I understand this patch came in this way for .36
> >>  (I took it from .36-stable)
> >
> >  The patch was autotested for .36-stable, it wasn't autotested for
> >  .35-stable.  It will very likely work (this isn't code that changes a lot),
> >  but still.
> >
> >>  >    - They then submit the patches to stable@
> >>
> >>  Do you want to do the autotest explicitely for .35 too and no automatic
> >>  backports and do the same procedure as for newer kernels?
> >>
> >>  I can do that, but you would need to do it for a long time.
> >
> >  Yes.  In fact it gets more important as time goes by, since as time goes by
> >  patches are more likely to cause regressions due to changes in the code
> >  base.
>
> My workflow is largely the same as Andi's -- in that I'm using patches that
> have already been nominated for other stable releases and putting them
> on the 34-lt (longterm) as appropriate.  Are you interested in also doing the
> same thing for 34-lt (i.e. you generating a 34 specific, pre-tested patchset
> instead of me doing the backports from other stable trees?)

Wait, there's a 34-lt too?

I'd like to have all stable kvms pass some minimum acceptance test, but 
that's quiet a lot of trees to maintain.  Why do we have to have both 
34-lt and 35-lt?

-- 
error compiling committee.c: too many arguments to function

