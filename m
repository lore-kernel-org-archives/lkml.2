Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab2EJJ0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:26:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273Ab2EJJ0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:26:35 -0400
Message-ID: <4FAB89AE.2030301@redhat.com>
Date: Thu, 10 May 2012 12:26:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] bitops: add _local bitops
References: <20120509134528.GA18044@redhat.com> <20120509121940.459e93ba.akpm@linux-foundation.org> <20120509200735.GA22743@redhat.com> <4FAACF1C.2060504@zytor.com> <20120509201223.GB22743@redhat.com>
In-Reply-To: <20120509201223.GB22743@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 11:12 PM, Michael S. Tsirkin wrote:
> On Wed, May 09, 2012 at 01:10:04PM -0700, H. Peter Anvin wrote:
> > On 05/09/2012 01:07 PM, Michael S. Tsirkin wrote:
> > > 
> > > In practice ATM any of the above will work. We probably don't even need
> > > to add barrier() calls since what we do afterwards is apic access which
> > > has an optimization barrier anyway.  But I'm fine with adding them in
> > > there just in case if that's what people want.
> > > 
> > 
> > If you have the optimization barrier anyway, then I'd be fine with you
> > just using __test_and_clear_bit() and add to a comment in
> > arch/x86/include/asm/bitops.h that KVM needs it to be locally atomic.
> > 
> > 	-hpa
>
> Sounds good. Avi?

Okay.

-- 
error compiling committee.c: too many arguments to function

