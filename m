Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332Ab2EVTuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:50:03 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46750 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758356Ab2EVTuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:50:01 -0400
Date: Tue, 22 May 2012 15:43:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: Ian.Campbell@citrix.com, jeremy@goop.org, netdev@vger.kernel.org,
        marmarek@invisiblethingslab.com,
        virtualization@lists.linux-foundation.org, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: do not disable netfront in dom0
Message-ID: <20120522194319.GA2691@phenom.dumpdata.com>
References: <20120522130558.D828E6C7@duch.mimuw.edu.pl>
 <20120522.151354.2131168749992255398.davem@davemloft.net>
 <1337715028.3991.2.camel@dagon.hellion.org.uk>
 <20120522.153847.2107186222464601466.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522.153847.2107186222464601466.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 03:38:47PM -0400, David Miller wrote:
> From: Ian Campbell <Ian.Campbell@citrix.com>
> Date: Tue, 22 May 2012 20:30:28 +0100
> 
> > On Tue, 2012-05-22 at 20:13 +0100, David Miller wrote:
> >> From: Marek Marczykowski <marmarek@invisiblethingslab.com>
> >> Date: Sun, 20 May 2012 13:45:10 +0200
> >> 
> >> > Netfront driver can be also useful in dom0, eg when all NICs are assigned to
> >> > some domU (aka driver domain). Then using netback in domU and netfront in dom0
> >> > is the only way to get network access in dom0.
> >> > 
> >> > Signed-off-by: Marek Marczykowski <marmarek@invisiblethingslab.com>
> >> 
> >> Someone please review this and I can merge it in via the 'net' tree if
> >> it looks OK to XEN folks.
> > 
> > Konrad is "Xen folks" and has acked it already but FWIW:
> > 
> > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
> Ok, but this patch doesn't appply cleanly at all to Linus's
> current tree nor my 'net' tree (which are equal right now).

Oh no! Marek, can you repin it please (along with all the Ack's on it).
