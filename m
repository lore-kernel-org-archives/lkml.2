Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab2JWKe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:34:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56971 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973Ab2JWKeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:34:09 -0400
Date: Tue, 23 Oct 2012 11:33:52 +0100
From: Will Deacon <will.deacon@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "levinsasha928@gmail.com" <levinsasha928@gmail.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "ericvh@gmail.com" <ericvh@gmail.com>
Subject: Re: [PATCH v2 1/3] mm: highmem: export kmap_to_page for modules
Message-ID: <20121023103352.GC20210@mudshark.cambridge.arm.com>
References: <1350651813-8694-1-git-send-email-will.deacon@arm.com>
 <87objuhxiq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87objuhxiq.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 12:55:57AM +0100, Rusty Russell wrote:
> Will Deacon <will.deacon@arm.com> writes:
> 
> > Some virtio device drivers (9p) need to translate high virtual addresses
> > to physical addresses, which are inserted into the virtqueue for
> > processing by userspace.
> >
> > This patch exports the kmap_to_page symbol, so that the affected drivers
> > can be compiled as modules.
> 
> Thanks Will!
> 
> I've applied these, and add cc:stable.  I'll push them to Linus after a
> little time in linux-next.

Cheers Rusty. Andrew's right about this affecting highmem on x86 too (I
guess that's what Sasha saw with the 9p memory issues), so stable makes
sense.

Will
