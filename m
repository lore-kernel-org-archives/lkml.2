Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2GRQDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:03:44 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57307 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2GRQDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:03:41 -0400
Subject: Re: QUESTION: Why might Linux suddenly stop replying to pings for
 no apparent reason?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Terry Phelps <tgphelps50@gmail.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAMUfR_to9bD2PE8+6Y4we0YG-ULkAVxASByK4_mn7WTmyS9g5Q@mail.gmail.com>
References: <CAMUfR_vogZUgJB5QBr-QrYqFEM71J_pyvc=cFRV6apvb=pVJuQ@mail.gmail.com>
	 <CAFLxGvzOzNj5ab82RDV=kn_a6Bb16sKT=GfK3igVM3pk7CkC4Q@mail.gmail.com>
	 <CAMUfR_to9bD2PE8+6Y4we0YG-ULkAVxASByK4_mn7WTmyS9g5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jul 2012 18:03:36 +0200
Message-ID: <1342627416.2626.3047.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 11:42 -0400, Terry Phelps wrote:
> On Wed, Jul 18, 2012 at 11:06 AM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
> > On Wed, Jul 18, 2012 at 4:42 PM, Terry Phelps <tgphelps50@gmail.com> wrote:
> >> I have this strange recurring problem with SEVERAL machines, all
> >> running the Oracle "Unbreakable Enterprise Kernel", which is based on
> >> the 3.0.16 kernel.
> >
> > Ask Oracle.
> 
> Is there some way to "ask Oracle", in which my question will get to
> someone who can possibly help me? I've tried contacting "Oracle Linux
> support". They're hopeless. I've posted my question to Oracle forums,
> and even general Linux forums, but all I get is boilerplate networking
> advice (check ifconfig, check your routes, check your switches, check
> autonegotiation, etc.) that doesn't address the specific symptoms I'm
> seeing.
> 
> If I should be posting my question to somewhere other than the
> linux-kernel mailing list, please advise me where that might be. It
> sure looks like something in the kernel isn't working properly
> somewhere.

Before saying that, can you try a pristine linux kernel ?

For example linux-3.4.5, or even better the git tree, so that
it will be easier to add knobs and patches.

Obviously we dont know what Oracle added to their kernels, and
dont want to know.



