Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1KIMhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:37:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37461 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab1KIMg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:36:59 -0500
Date: Wed, 9 Nov 2011 14:36:43 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Sasha Levin <levinsasha928@gmail.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@cs.helsinki.fi
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
In-Reply-To: <1320841683.31056.41.camel@lappy>
Message-ID: <alpine.LFD.2.02.1111091434230.4936@tux.localdomain>
References: <87wrbkvh3v.fsf@rustcorp.com.au>  <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy>  <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au>  <20111102233110.GA20289@redhat.com> <20111108214021.GA4538@redhat.com>
  <1320828366.31056.16.camel@lappy> <20111109101318.GB20612@redhat.com>  <alpine.LFD.2.02.1111091421570.4936@tux.localdomain> <1320841683.31056.41.camel@lappy>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Nov 2011, Sasha Levin wrote:
> They don't exist in kernel code either, for same reason as above.
>
> Nothing will break if we remove it since no one really used it, we were
> probably the first and only implementation of the spec which considered
> them :)

As long as we are able to run older versions of the KVM tool with newer 
kernels and vice versa, I see no reason why we can't drop 64-bit features 
from the KVM tool.

 			Pekka
