Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab1K3Eo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 23:44:29 -0500
Received: from ozlabs.org ([203.10.76.45]:37280 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab1K3EoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 23:44:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
In-Reply-To: <20111128084009.GB20084@redhat.com>
References: <20111122183621.GA5235@redhat.com> <87hb1v1scp.fsf@rustcorp.com.au> <20111123084640.GE22734@redhat.com> <87ty5uxso3.fsf@rustcorp.com.au> <20111124070728.GH29994@redhat.com> <87vcq5t69c.fsf@rustcorp.com.au> <20111128084009.GB20084@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 30 Nov 2011 09:58:45 +1030
Message-ID: <87sjl6tsnm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Nov 2011 10:41:51 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, Nov 28, 2011 at 11:25:43AM +1030, Rusty Russell wrote:
> > > > But I'm *terrified* of making the spec more complex;
> > > 
> > > All you do is move stuff around. Why do you think it simplifies the spec
> > > so much?
> > 
> > No, but it reduces the yuk factor.  Which has been important to adoption.
> 
> Sorry if I'm dense. Could you please clarify: do you think we can live
> with the slightly higher yuk factor assuming the spec moves the
> legacy mode into an appendix as you explain below and driver has a
> single 'legacy' switch?

Yep, it's all a trade-off.  A clean slate is good, but if we can make
our lives in transition less painful, I'm all for it.

> I think I see a way to do that in a relatively painless way.
> Do you prefer seeing driver patches or spec? Or are you not interested
> in reusing the same structure at all?

I think we should look at code at this point; my gut says we're going to
be not-quite-similar-enough-to-be-useful.  At which point, a clean-slate
approach is more appealing.  But the code will show, one way or another.

Thanks,
Rusty.
