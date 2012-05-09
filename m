Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739Ab2EIXGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:06:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42843 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759223Ab2EIXGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:06:51 -0400
X-Sasl-enc: VdPIeiAnmbUKoia7GLjo+HdqN/gXd1ysPrgMWqwz3MN4 1336604810
Date: Wed, 9 May 2012 16:06:49 -0700
From: Greg Kroah-Hartmann <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kay Sievers <kay@vrfy.org>, Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
Message-ID: <20120509230649.GA10695@kroah.com>
References: <1336004953.4240.9.camel@mop>
 <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop>
 <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
 <1336571457.30189.29.camel@joe2Laptop>
 <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
 <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 04:02:40PM -0700, Yinghai Lu wrote:
> On Wed, May 9, 2012 at 7:37 AM, Kay Sievers <kay@vrfy.org> wrote:
> >
> >> Changing printk semantics and trying to stabilize
> >> printk message content are bad ideas though.
> >
> > Again, nobody talks about content of here.
> 
> printk_time=1 does not work anymore with this patch on serial console.

Known issue, I think Kay is working on the solution for this right
now...

greg k-h
