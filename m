Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208Ab0J2LSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 07:18:11 -0400
Received: from ozlabs.org ([203.10.76.45]:42372 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759688Ab0J2LSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 07:18:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
Date: Fri, 29 Oct 2010 21:48:00 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
Cc: Ian Molton <ian.molton@collabora.co.uk>, Avi Kivity <avi@redhat.com>,
        virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
        QEMU Developers <qemu-devel@nongnu.org>
References: <4CAC9CD1.2050601@collabora.co.uk> <4CBD7560.6080207@redhat.com> <4CC8226F.5080807@collabora.co.uk>
In-Reply-To: <4CC8226F.5080807@collabora.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010292148.01167.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 11:30:31 pm Ian Molton wrote:
> On 19/10/10 11:39, Avi Kivity wrote:
> > On 10/19/2010 12:31 PM, Ian Molton wrote:
> 
> >>> 2. should start with a patch to the virtio-pci spec to document what
> >>> you're doing
> >>
> >> Where can I find that spec?
> >
> > http://ozlabs.org/~rusty/virtio-spec/
> 
> Ok, but I'm not patching that until theres been some review.

Fair enough; it's a bit of a PITA to patch, so it makes sense to get the
details nailed down first.

> There are links to the associated qemu and guest OS changes in my 
> original email.
> 
> >> It doesnt, at present... It could be changed fairly easily ithout
> >> breaking anything if that happens though.
> >
> > The hypervisor and the guest can be changed independently. The driver
> > should be coded so that it doesn't depend on hypervisor implementation
> > details.
> 
> Fixed - updated patch tested and attached.

OK. FWIW, I think this is an awesome idea.  I understand others are skeptical,
but this seems simple and if it works and you're happy to maintain it I'm
happy to let you do it :)

Cheers,
Rusty.
