Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1KPHVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:21:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab1KPHVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:21:53 -0500
Date: Wed, 16 Nov 2011 09:21:38 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@kernel.org
Subject: Re: [PATCHv2 RFC] virtio-spec: flexible configuration layout
Message-ID: <20111116072137.GF5433@redhat.com>
References: <8739e7uy87.fsf@rustcorp.com.au>
 <20111102233110.GA20289@redhat.com>
 <20111108214021.GA4538@redhat.com>
 <20111109195901.GA28155@redhat.com>
 <1320870287.3730.6.camel@lappy>
 <20111109205208.GA28599@redhat.com>
 <1320872248.3730.11.camel@lappy>
 <87aa83qoao.fsf@rustcorp.com.au>
 <CA+1xoqeH3ErNCELD+NoJHz=eH6FtxersUffoJSj0yQx2o=4g0g@mail.gmail.com>
 <87aa7xos3n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87aa7xos3n.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 10:28:52AM +1030, Rusty Russell wrote:
> On Fri, 11 Nov 2011 09:39:13 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> > On Fri, Nov 11, 2011 at 6:24 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > (2) There's no huge win in keeping the same layout.  Let's make some
> > >    cleanups.  There are more users ahead of us then behind us (I
> > >    hope!).
> > 
> > Actually, if we already do cleanups, here are two more suggestions:
> > 
> > 1. Make 64bit features a one big 64bit block, instead of having 32bits
> > in one place and 32 in another.
> > 2. Remove the reserved fields out of the config (the ones that were
> > caused by moving the ISR and the notifications out).
> 
> Yes, those were exactly what I was thinking.  I left it vague because
> there might be others you can see if we're prepared to abandon the
> current format.
> 
> Cheers,
> Rusty.

Yes but driver code doesn't get any cleaner by moving the fields.
And in fact, the legacy support makes the code messier.
What are the advantages?

-- 
MST
