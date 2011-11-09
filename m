Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1KIMkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:40:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab1KIMkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:40:15 -0500
Message-ID: <4EBA744D.8020107@redhat.com>
Date: Wed, 09 Nov 2011 14:38:37 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
References: <87wrbkvh3v.fsf@rustcorp.com.au>  <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy>  <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au>  <20111102233110.GA20289@redhat.com>  <20111108214021.GA4538@redhat.com> <1320828366.31056.16.camel@lappy>
In-Reply-To: <1320828366.31056.16.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 10:46 AM, Sasha Levin wrote:
> > Alternatively we can add new structures with new
> > structure IDs, pointed to from PCI configuration space.
> > 
> > As we don't yet have devices or drivers with 64 bit features,
> > I decided we don't need high feature bits in legacy space.
> > This also frees up feature bit 31 as we don't need it
> > to enable high feature bits anymore.
>
> KVM tool actually has support for 64bit features, we can probably remove
> that when Pekka isn't looking :)
>

What about the Windows drivers?

-- 
error compiling committee.c: too many arguments to function

