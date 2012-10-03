Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab2JCIWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:22:39 -0400
Received: from ozlabs.org ([203.10.76.45]:59222 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab2JCIWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:22:35 -0400
Message-ID: <1349252551.31536.29.camel@concordia>
Subject: Re: linux-next: fate of the kvmtool tree
From: Michael Ellerman <michael@ellerman.id.au>
To: Pekka Enberg <penberg@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 03 Oct 2012 18:22:31 +1000
In-Reply-To: <CAOJsxLFeVa6WCpr25t3hA3xGJb6rUgFqOLDrc5_3iLnUb-xTHw@mail.gmail.com>
References: <20121003152921.c08e7019d2ada843888a2570@canb.auug.org.au>
	 <CAOJsxLFeVa6WCpr25t3hA3xGJb6rUgFqOLDrc5_3iLnUb-xTHw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 09:47 +0300, Pekka Enberg wrote:
> Hi Stephen,
> 
> On Wed, Oct 3, 2012 at 8:29 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Well, here we are at another merge window and the kvmtool tree is still
> > not merged.  So, is it likely that it will be merged in this merge
> > window?  or the next?  If not, can I please remove it from linux-next
> > (and have it removed from the auto-latest branch of the tip tree) as it
> > just adds weight to the patches and the tree that people have to fetch to
> > work with.
> 
> I have no idea how likely it is that it will be merged but I'm
> planning to send a pull request for this merge cycle. ;-)

Hi Pekka,

I just noticed kvmtool doesn't build for powerpc anymore, since 8074303
"remove global kvm object".

It'd be nice if it wasn't broken when it hit Linus' tree, I'll try and
get you a patch in the next day.

cheers

