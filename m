Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab2EVTbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:31:06 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:54984 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2EVTbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:31:04 -0400
X-IronPort-AV: E=Sophos;i="4.75,639,1330905600"; 
   d="scan'208";a="12611983"
Message-ID: <1337715028.3991.2.camel@dagon.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] xen: do not disable netfront in dom0
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Miller <davem@davemloft.net>
CC: "marmarek@invisiblethingslab.com" <marmarek@invisiblethingslab.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Date: Tue, 22 May 2012 20:30:28 +0100
In-Reply-To: <20120522.151354.2131168749992255398.davem@davemloft.net>
References: <20120522130558.D828E6C7@duch.mimuw.edu.pl>
	 <20120522.151354.2131168749992255398.davem@davemloft.net>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 20:13 +0100, David Miller wrote:
> From: Marek Marczykowski <marmarek@invisiblethingslab.com>
> Date: Sun, 20 May 2012 13:45:10 +0200
> 
> > Netfront driver can be also useful in dom0, eg when all NICs are assigned to
> > some domU (aka driver domain). Then using netback in domU and netfront in dom0
> > is the only way to get network access in dom0.
> > 
> > Signed-off-by: Marek Marczykowski <marmarek@invisiblethingslab.com>
> 
> Someone please review this and I can merge it in via the 'net' tree if
> it looks OK to XEN folks.

Konrad is "Xen folks" and has acked it already but FWIW:

Acked-by: Ian Campbell <ian.campbell@citrix.com>

Ian.

> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel


