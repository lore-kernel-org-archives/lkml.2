Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1KCNwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:52:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab1KCNwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:52:14 -0400
Date: Thu, 3 Nov 2011 15:53:17 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Sasha Levin <levinsasha928@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] virtio-pci: flexible configuration layout
Message-ID: <20111103135316.GN18296@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
 <20111101114542.GA13434@redhat.com>
 <1320150813.3847.24.camel@lappy>
 <20111101124223.GA14060@redhat.com>
 <8739e7uy87.fsf@rustcorp.com.au>
 <20111102233110.GA20289@redhat.com>
 <4EB26ED0.3080409@redhat.com>
 <20111103121139.GF18296@redhat.com>
 <4EB29926.9030509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB29926.9030509@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 03:37:42PM +0200, Avi Kivity wrote:
> On 11/03/2011 02:11 PM, Michael S. Tsirkin wrote:
> > On Thu, Nov 03, 2011 at 12:37:04PM +0200, Avi Kivity wrote:
> > > On 11/03/2011 01:31 AM, Michael S. Tsirkin wrote:
> > > > Add a flexible mechanism to specify virtio configuration layout, using
> > > > pci vendor-specific capability.  A separate capability is used for each
> > > > of common, device specific and data-path accesses.
> > > >
> > > >
> > > 
> > > How about posting the spec change instead of patches?
> >
> > We need both of course but I typically start with patches.
> > Easier to see whether it's even possible to implement the
> > spec without overhauling all of the code.
> 
> Patches are okay for someone familiar with the code.  For others, they
> require more effort.

Yes. It's just that I needed to convince myself that the approach is good,
and that meant writing the supporting code. Since I had the code
I didn't see a reason not to send it :)

> -- 
> error compiling committee.c: too many arguments to function
