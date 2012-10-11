Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2JKIIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:08:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab2JKIH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:07:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3A78FAA0EC814D4B8ECC99B3AB32B33208612DA4@fmsmsx110.amr.corp.intel.com>
References: <3A78FAA0EC814D4B8ECC99B3AB32B33208612DA4@fmsmsx110.amr.corp.intel.com> <30770.1349789450@warthog.procyon.org.uk>
To: davem@davemloft.net
Cc: dhowells@redhat.com, linux-wimax <linux-wimax@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        netdev@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for wimax
Date: Thu, 11 Oct 2012 09:07:52 +0100
Message-ID: <11849.1349942872@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dave,

Can you pull wimax as well?

Sorry about this, but it seems like the majority of the non-arch trees need to
go through the networking tree.

Perez-Gonzalez, Inaky <inaky.perez-gonzalez@intel.com> wrote:

> > From: David Howells [mailto:dhowells@redhat.com]
> > 
> > Can you merge the following branch into the wimax tree please.
> > ...
> 
> This can be submitted straight to Dave Miller, as there is no separate wimax
> tree anymore, it is in pure maintenance mode.
> 
> BTW: thanks for tackling the UAPI issue
> 
> Acked-by: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>

Thanks,
David
---
The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:

  Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-wimax-20121009

for you to fetch changes up to 1e256b340d9574fd1bf31b73f16c4c474502692c:

  UAPI: (Scripted) Disintegrate include/linux/wimax (2012-10-09 09:49:08 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/linux/wimax

 include/linux/wimax/Kbuild              | 1 -
 include/uapi/linux/wimax/Kbuild         | 1 +
 include/{ => uapi}/linux/wimax/i2400m.h | 0
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename include/{ => uapi}/linux/wimax/i2400m.h (100%)
.
