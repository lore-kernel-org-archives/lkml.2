Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1KCNiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:38:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1KCNiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:38:19 -0400
Message-ID: <4EB29926.9030509@redhat.com>
Date: Thu, 03 Nov 2011 15:37:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
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
References: <87wrbkvh3v.fsf@rustcorp.com.au> <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy> <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au> <20111102233110.GA20289@redhat.com> <4EB26ED0.3080409@redhat.com> <20111103121139.GF18296@redhat.com>
In-Reply-To: <20111103121139.GF18296@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 02:11 PM, Michael S. Tsirkin wrote:
> On Thu, Nov 03, 2011 at 12:37:04PM +0200, Avi Kivity wrote:
> > On 11/03/2011 01:31 AM, Michael S. Tsirkin wrote:
> > > Add a flexible mechanism to specify virtio configuration layout, using
> > > pci vendor-specific capability.  A separate capability is used for each
> > > of common, device specific and data-path accesses.
> > >
> > >
> > 
> > How about posting the spec change instead of patches?
>
> We need both of course but I typically start with patches.
> Easier to see whether it's even possible to implement the
> spec without overhauling all of the code.

Patches are okay for someone familiar with the code.  For others, they
require more effort.

-- 
error compiling committee.c: too many arguments to function

