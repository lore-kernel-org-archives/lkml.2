Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2FDCTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 22:19:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61397 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2FDCTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 22:19:13 -0400
Date: Mon, 4 Jun 2012 10:18:40 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Richard Kuo <rkuo@codeaurora.org>, David Howells <dhowells@redhat.com>,
        Bob Liu <lliubbo@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Richard Weinberger <richard@nod.at>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Matt Turner <mattst88@gmail.com>, nikunj@linux.vnet.ibm.com
Subject: Re: [PATCH 01/27] smpboot: Provide a generic method to boot
 secondary processors
Message-ID: <20120604021839.GB26319@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
 <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com>
 <4FC8B0F7.3060705@linux.vnet.ibm.com>
 <20120603085107.GD16829@zhy>
 <4FCB48EF.8050508@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FCB48EF.8050508@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 04:52:23PM +0530, Srivatsa S. Bhat wrote:
> In short, to avoid breaking build on x86.
> We wanted to follow the x86 convention of having static inline functions in
> arch/x86/include/asm/smp.h and use the smp_ops structure to route the calls
> to x86 or xen as appropriate (see patch 4 in this series).
> 
> But __weak definitions interfere with that and break the build. Hence, we
> followed what Linus suggested doing in a similar context:
> https://lkml.org/lkml/2008/7/26/187

Good to know that, thanks for your explanation.

Yong
