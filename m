Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab1HQBTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 21:19:24 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:17182 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1HQBTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 21:19:22 -0400
Subject: Re: linux-next: boot test failure (net tree)
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
In-Reply-To: <20110816.175657.1688139393736610845.davem@davemloft.net>
References: <20110817100146.3b557cf815a5a2ae09bc09a7@canb.auug.org.au>
	 <20110816.171525.639251389938336183.davem@davemloft.net>
	 <20110817105002.efebf85d08460ad99b14be8e@canb.auug.org.au>
	 <20110816.175657.1688139393736610845.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 17 Aug 2011 02:19:12 +0100
Message-ID: <1313543952.2981.132.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Aug 2011 01:19:21.0826 (UTC) FILETIME=[B1A8BC20:01CC5C7B]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18326.005
X-TM-AS-Result: No--16.827800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 17:56 -0700, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 17 Aug 2011 10:50:02 +1000
> 
> > Which is a bit of a pain for automated systems.  Ours does (essentially):
> > 
> > yes '' | make oldconfig
> > 
> > We really don't want to select every new config item that comes along.
> 
> If you're indeed piping "yes" output to "make oldconfig" on an
> existing config, it would select the new guards for you.
[....]

If you were to use just "yes", then of course it would.  But since there
is no explicit default, "yes ''" will deselect them.

Maybe these guards should have "default y"?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

