Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030692Ab2B2DVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 22:21:48 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:9954 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755192Ab2B2DVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 22:21:46 -0500
Message-ID: <1330485702.2512.22.camel@bwh-desktop>
Subject: Re: linux-next: manual merge of the net-next tree with Linus' tree
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
CC: <sfr@canb.auug.org.au>, <netdev@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 29 Feb 2012 03:21:42 +0000
In-Reply-To: <20120226.230523.1906949835561978402.davem@davemloft.net>
References: <20120227121125.007c32f9aa7be2470d9e3356@canb.auug.org.au>
	 <20120226.230523.1906949835561978402.davem@davemloft.net>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18740.005
X-TM-AS-Result: No--14.111000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-26 at 23:05 -0500, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 27 Feb 2012 12:11:25 +1100
> 
> > Today's linux-next merge of the net-next tree got a conflict in
> > drivers/net/ethernet/sfc/rx.c between commit ff3bc1e75275 ("sfc: Fix
> > assignment of ip_summed for pre-allocated skbs") from Linus' tree and
> > commit db3395697cad ("sfc: Replace efx_rx_buffer::is_page and other
> > booleans with a flags field") from the net-next tree.
> > 
> > Just context changes.  I fixed it up (see below) and can carry the fix as
> > necessary.
> 
> I just merged net into net-next and resolved this conflict.

Thank you both.  I should have flagged this when sending the change for
the net tree.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

