Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1KIK2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:28:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46781 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1KIK2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:28:02 -0500
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@cs.helsinki.fi
In-Reply-To: <20111109101318.GB20612@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
	 <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy>
	 <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au>
	 <20111102233110.GA20289@redhat.com> <20111108214021.GA4538@redhat.com>
	 <1320828366.31056.16.camel@lappy>  <20111109101318.GB20612@redhat.com>
Content-Type: text/plain; charset="iso-8859-13"
Date: Wed, 09 Nov 2011 12:26:08 +0200
Message-ID: <1320834368.31056.31.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 12:13 +0200, Michael S. Tsirkin wrote:
> On Wed, Nov 09, 2011 at 10:46:06AM +0200, Sasha Levin wrote:
> > The device initialization sequence might use an update as well.
> 
> What is needed? Add an item where the driver scans the PCI capability
> list to detect the layout?

Yup, something similar like that - just to make it obvious.

> > Maybe
> > also a description of how device handles missing structure IDs.
> > 
> > [snip]
> 
> Hmm. I just have
> 'Drivers should fall back on this legacy structure if a
>  Virtio Structure capability is missing in the PCI capability
>  list'. 
> 
> What else would be helpful? An example? 

I just remembered from your patch that you could define some structure
IDs, but not necessarily all of them, if it's not longer the case then
ignore me. If it is, then the scenario of a missing structure should be
specified (For example, if the ISR structure wasn't defined, fall back
to...).

> > I'm not sure what capability length is, can't find it in the spec
> > either.
> > 
> > [snip]
> 
> It's the legth of the vendor specific capability structure in bytes.
> 'the byte immediately following the ´Next¡
>  pointer in the capability structure is defined to be a length field'
> It's on page 330 in my copy.

Right, I was looking only at the regular cap definition.

-- 

Sasha.

