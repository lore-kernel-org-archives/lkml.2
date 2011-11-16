Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab1KPCdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 21:33:12 -0500
Received: from ozlabs.org ([203.10.76.45]:46737 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab1KPCdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 21:33:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] virtio: add HAS_IOMEM dependency to MMIO platform bus driver
In-Reply-To: <1321353118.3137.92.camel@hornet.cambridge.arm.com>
References: <1321348404-3549-1-git-send-email-heiko.carstens@de.ibm.com> <1321353118.3137.92.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 16 Nov 2011 10:58:30 +1030
Message-ID: <87vcqkoqq9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011 10:31:58 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> On Tue, 2011-11-15 at 09:13 +0000, Heiko Carstens wrote:
> > Fix this compile error on s390:
> > 
> >   CC [M]  drivers/virtio/virtio_mmio.o
> > drivers/virtio/virtio_mmio.c: In function 'vm_get_features':
> > drivers/virtio/virtio_mmio.c:107:2: error: implicit declaration of function 'writel'
> 
> One learns something new every day :-O
> 
> Thanks and apologies for inconvenience!
> 
> > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > Cc: Pawel Moll <pawel.moll@arm.com>
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Acked-by: Pawel Moll <pawel.moll@arm.com>

Applied, thanks!

Cheers,
Rusty.
