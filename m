Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab0JRSeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:34:20 -0400
Received: from relay2.sgi.com ([192.48.179.30]:53649 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755239Ab0JRSeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:34:19 -0400
Date: Mon, 18 Oct 2010 13:34:17 -0500
From: Robin Holt <holt@sgi.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Robin Holt <holt@sgi.com>, David Miller <davem@davemloft.net>, w@1wt.eu,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [Patch] Limit sysctl_tcp_mem and sysctl_udp_mem initializers
 to prevent integer overflows.
Message-ID: <20101018183417.GH14064@sgi.com>
References: <20101002112405.951704198@gulag1.americas.sgi.com>
 <20101002112419.248437367@gulag1.americas.sgi.com>
 <20101005.145032.25126909.davem@davemloft.net>
 <20101018174339.GC14068@sgi.com>
 <1287424348.2359.1.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287424348.2359.1.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 07:52:28PM +0200, Eric Dumazet wrote:
> Le lundi 18 octobre 2010 à 12:43 -0500, Robin Holt a écrit :
> > On Tue, Oct 05, 2010 at 02:50:32PM -0700, David Miller wrote:
> > > From: Robin Holt <holt@sgi.com>
> > > Date: Sat, 02 Oct 2010 06:24:06 -0500
> > > 
> > > > Subject: [Patch] Limit sysctl_tcp_mem and sysctl_udp_mem initializers to prevent integer overflows.
> > > > 
> > > > On a 16TB x86_64 machine, sysctl_tcp_mem[2], sysctl_udp_mem[2], and
> > > > sysctl_sctp_mem[2] can integer overflow.  Set limit such that they are
> > > > maximized without overflowing.
> > > > 
> > > > Signed-off-by: Robin Holt <holt@sgi.com>
> > > 
> > > Robin please resubmit this with the SCTP bits included.
> > 
> > David,
> > 
> > I did not mean to blow you off.  I was not going to resubmit because
> > Eric's patch is the preferred direction.  I had been given an indication
> > that my patch was preferred, but that indicator changed.
> > 
> 
> Maybe there is some misunderstanding.
> 
> My patch was for net-next kernels (not before 2.6.37), while yours was
> applicable to previous kernels.

Ah.  I will resubmit then.

Sorry for the confusion,
Robin
