Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1KIPuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 10:50:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1KIPui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 10:50:38 -0500
Date: Wed, 9 Nov 2011 17:51:37 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
Message-ID: <20111109155137.GA25664@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
 <20111101114542.GA13434@redhat.com>
 <1320150813.3847.24.camel@lappy>
 <20111101124223.GA14060@redhat.com>
 <8739e7uy87.fsf@rustcorp.com.au>
 <20111102233110.GA20289@redhat.com>
 <20111108214021.GA4538@redhat.com>
 <1320828366.31056.16.camel@lappy>
 <4EBA744D.8020107@redhat.com>
 <1320842938.31056.55.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320842938.31056.55.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 02:48:58PM +0200, Sasha Levin wrote:
> I was unable to check if it was actually implemented in the drivers
> because
> http://git.kernel.org/?p=virt/kvm/kvm-guest-drivers-windows.git;a=summary is not quite there (*cough*).

I found a mirror:
http://mirror.nexcess.net/kernel.org/scm/virt/kvm/kvm-guest-drivers-windows.git/
don't know how fresh it is.

> -- 
> 
> Sasha.
> 
