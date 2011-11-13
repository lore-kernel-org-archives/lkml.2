Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1KMUko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 15:40:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab1KMUkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 15:40:43 -0500
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
From: Vadim Rozenfeld <vrozenfe@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Krishna Kumar <krkumar2@in.ibm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>, kvm@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Amit Shah <amit.shah@redhat.com>
In-Reply-To: <4EBA744D.8020107@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
	 <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy>
	 <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au>
	 <20111102233110.GA20289@redhat.com> <20111108214021.GA4538@redhat.com>
	 <1320828366.31056.16.camel@lappy>  <4EBA744D.8020107@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 22:40:20 +0200
Message-ID: <1321216820.15736.5.camel@vadimr.dell>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 14:38 +0200, Avi Kivity wrote:
> On 11/09/2011 10:46 AM, Sasha Levin wrote:
> > > Alternatively we can add new structures with new
> > > structure IDs, pointed to from PCI configuration space.
> > > 
> > > As we don't yet have devices or drivers with 64 bit features,
> > > I decided we don't need high feature bits in legacy space.
> > > This also frees up feature bit 31 as we don't need it
> > > to enable high feature bits anymore.
> >
> > KVM tool actually has support for 64bit features, we can probably remove
> > that when Pekka isn't looking :)
> >
> 
> What about the Windows drivers?
> 
Probably some small adjustments will be required,
but I don't see any major problem here.

Vadim. 


