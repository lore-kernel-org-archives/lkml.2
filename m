Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab2FRMIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:08:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab2FRMIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:08:11 -0400
Date: Mon, 18 Jun 2012 15:07:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@cs.helsinki.fi
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
Message-ID: <20120618120727.GB25390@redhat.com>
References: <8739e7uy87.fsf@rustcorp.com.au>
 <20111102233110.GA20289@redhat.com>
 <20111108214021.GA4538@redhat.com>
 <1320828366.31056.16.camel@lappy>
 <20111109101318.GB20612@redhat.com>
 <alpine.LFD.2.02.1111091421570.4936@tux.localdomain>
 <1320841683.31056.41.camel@lappy>
 <alpine.LFD.2.02.1111091434230.4936@tux.localdomain>
 <20120618115440.GA25042@redhat.com>
 <1340021117.22848.3.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340021117.22848.3.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 02:05:17PM +0200, Sasha Levin wrote:
> On Mon, 2012-06-18 at 14:54 +0300, Michael S. Tsirkin wrote:
> > On Wed, Nov 09, 2011 at 02:36:43PM +0200, Pekka Enberg wrote:
> > > On Wed, 9 Nov 2011, Sasha Levin wrote:
> > > >They don't exist in kernel code either, for same reason as above.
> > > >
> > > >Nothing will break if we remove it since no one really used it, we were
> > > >probably the first and only implementation of the spec which considered
> > > >them :)
> > > 
> > > As long as we are able to run older versions of the KVM tool with
> > > newer kernels and vice versa, I see no reason why we can't drop
> > > 64-bit features from the KVM tool.
> > > 
> > > 			Pekka
> > 
> > So what happened? Did you guys do this?  Need to know what to do to make
> > progress.  IIUC Rusty removed the new fields in 0.9.3.
> > Does your tool still use them? Did any version of the tool released by
> > distros do so?
> 
> Yup, they were removed quite a while ago.

Thanks, that's nice. So we can reuse that bit if we need it
and it won't break your code.

-- 
MST
