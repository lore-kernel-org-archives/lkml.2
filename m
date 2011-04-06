Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1DFJds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:33:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37073 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab1DFJdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:33:47 -0400
Date: Wed, 6 Apr 2011 11:33:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, aarcange@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110406093333.GB6465@elte.hu>
References: <1301592656.586.15.camel@jaguar>
 <4D982E89.8070502@redhat.com>
 <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
 <4D9847BC.9060906@redhat.com>
 <4D98716D.9040307@codemonkey.ws>
 <4D9873CD.3080207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9873CD.3080207@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Sure, any succcesful project becomes an ugly gooball.  It's almost a 
> compliment.

I disagree strongly with that sentiment and there's several good counter 
examples:

 - the Git project is also highly successful and is kept very clean (and has a 
   project size comparable to Qemu)

 - the Linux kernel is also very clean in all areas i care about and has most
   of its ugliness stuffed into drivers/staging/ (and has a project size more 
   than an order of magnitude larger than Qemu).

In fact i claim the exact opposite: certain types of projects can only grow 
beyond a certain size and stay healthy if they are *not* ugly gooballs. 

Examples: X11 and GCC - both were struggling for years to break through magic 
invisible barriers of growth and IMHO a lot of it had to do with the lack of 
code (and development model) cleanliness.

So no, your kind of cynical, defeatist sentiment about code quality is by no 
means true in my experience. Projects become ugly gooballs once maintainers 
stop caring enough.

Thanks,

	Ingo
