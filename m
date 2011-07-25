Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab1GYHh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:37:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1GYHhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:37:21 -0400
Message-ID: <4E2D1D07.9020009@redhat.com>
Date: Mon, 25 Jul 2011 10:36:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Anthony Liguori <anthony@codemonkey.ws>, torvalds@linux-foundation.org,
        mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
References: <alpine.DEB.2.00.1107242335580.18045@tiger>	<4E2CC489.1090509@codemonkey.ws> <CAOJsxLH-poY4-wEUPqAa8bzK+1WJ0UYtSuue72RYwcd_D0kx_A@mail.gmail.com>
In-Reply-To: <CAOJsxLH-poY4-wEUPqAa8bzK+1WJ0UYtSuue72RYwcd_D0kx_A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 10:27 AM, Pekka Enberg wrote:
> Hi Anthony,
>
> On Mon, Jul 25, 2011 at 4:19 AM, Anthony Liguori<anthony@codemonkey.ws>  wrote:
> >  lguest already does this and lives in the kernel.
>
> Does Lguest have SMP, usermode networking, and GUI support?
>

IIRC, yes, no, and no.

> On Mon, Jul 25, 2011 at 4:19 AM, Anthony Liguori<anthony@codemonkey.ws>  wrote:
> >  So purely from a kernel perspective, why have two tools in the tree that do
> >  the same thing?  Shouldn't you at least unify the userspace with the lguest
> >  userspace?
>
> Are you talking about Documentation/lguest/lguest.c? How would you
> suggest we unify our code with that?

It should be easy to have tools/kvm drive lguest - they're both virtio 
based.  All you need to do is provide yet another ops structure to drive 
the two ABIs.

I guess lguest.c has to remain, as point of lguest was a simple teaching 
aid for virtualization (which doesn't work very well, as the techniques 
it uses are obsolete).

-- 
error compiling committee.c: too many arguments to function

