Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab1J0AGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 20:06:49 -0400
Received: from ozlabs.org ([203.10.76.45]:58595 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab1J0AGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 20:06:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <Pawel.Moll@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3] virtio: Add platform bus driver for memory mapped virtio device
In-Reply-To: <1319612222.2878.4.camel@rojo>
References: <1317841030-17758-1-git-send-email-pawel.moll@arm.com> <1317919843-8343-1-git-send-email-pawel.moll@arm.com> <1317921230.28696.102.camel@hornet.cambridge.arm.com> <87lisjq6tu.fsf@rustcorp.com.au> <1318931075.3146.285.camel@hornet.cambridge.arm.com> <87ty75adtb.fsf@rustcorp.com.au> <1319219844.5094.16.camel@hornet.cambridge.arm.com> <87wrbv15lp.fsf@rustcorp.com.au> <1319461560.3668.16.camel@hornet.cambridge.arm.com> <871uu0pfag.fsf@rustcorp.com.au> <1319612222.2878.4.camel@rojo>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 26 Oct 2011 22:20:54 +1030
Message-ID: <87ehy0nf8h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011 10:54:50 +0100, Pawel Moll <Pawel.Moll@arm.com> wrote:
> Morning,
> 
> > I've applied the corresponding changes to the latest version of the
> > virtio pci draft spec (0.9.2).  Please check it's accurate...
> >
> Just a typo (my fault probably ;-) in the InterruptStatus register
> description:
> * There is:  "Bit 0 | Use Ring Update"
> * Should be: "Bit 0 | Used Ring update"
> 
> The rest is just fine.

Thanks, that was me mangling it I think.  I won't release an update just
for that, but there's more coming...

Cheers,
Rusty.
