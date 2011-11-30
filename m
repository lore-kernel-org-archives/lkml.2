Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1K3HQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 02:16:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab1K3HQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 02:16:45 -0500
Date: Wed, 30 Nov 2011 09:18:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
Message-ID: <20111130071805.GC17781@redhat.com>
References: <20111122183621.GA5235@redhat.com>
 <87hb1v1scp.fsf@rustcorp.com.au>
 <20111123084640.GE22734@redhat.com>
 <87ty5uxso3.fsf@rustcorp.com.au>
 <20111124070728.GH29994@redhat.com>
 <87vcq5t69c.fsf@rustcorp.com.au>
 <20111128084009.GB20084@redhat.com>
 <87sjl6tsnm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjl6tsnm.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 09:58:45AM +1030, Rusty Russell wrote:
> > I think I see a way to do that in a relatively painless way.
> > Do you prefer seeing driver patches or spec? Or are you not interested
> > in reusing the same structure at all?
> 
> I think we should look at code at this point; my gut says we're going to
> be not-quite-similar-enough-to-be-useful.  At which point, a clean-slate
> approach is more appealing.  But the code will show, one way or another.
> 
> Thanks,
> Rusty.

Makes sense, absolutely. So I'll hack on it and post and we can
judge the result.

One small comment that I'm afraid was lost in the noise
is that we should not add any 64 bit fields in the common area,
because there's no generic iowrite64/ioread64.

-- 
MST
