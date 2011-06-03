Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab1FCWbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:31:15 -0400
Received: from mail.solarflare.com ([216.237.3.220]:29725 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab1FCWbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:31:14 -0400
Subject: Re: bridge/netfilter: regression in 2.6.39.1
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org
In-Reply-To: <1307129642.2600.2.camel@edumazet-laptop>
References: <4DE93422.3070000@ahsoftware.de>
	 <1307129642.2600.2.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Fri, 03 Jun 2011 23:31:10 +0100
Message-ID: <1307140270.22348.114.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 03 Jun 2011 22:31:13.0635 (UTC) FILETIME=[F20F7330:01CC223D]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18176.005
X-TM-AS-Result: No--24.389100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 21:34 +0200, Eric Dumazet wrote:
> Le vendredi 03 juin 2011 à 21:21 +0200, Alexander Holler a écrit :
> > Hello,
> > 
> > I'm getting a oops in the bridge code in br_change_mtu() with 2.6.39.1. 
> > The patch below seems to fix that.
> > 
> > I'm not sure about the usage of dst_cow_metrics_generic() in 
> > fake_dst_ops, but after having a quick look at it seems to be ok to use 
> > that here.
> > 
> > Regards,
> > 
> > Alexander
> > 
> > -----
> >  From 3c1d5951af73389798afeea672ec224e195b8e8d Mon Sep 17 00:00:00 2001
> > From: Alexander Holler <holler@ahsoftware.de>
> > Date: Fri, 3 Jun 2011 20:43:06 +0200
> > Subject: [PATCH] bridge: add dst_cow_metrics_generic to fake_dst_ops
> > 
> > Commit 42923465fb8d025a2b5153f2e7ab1e6e1058bf00 does here what it
> > should prevent, it introduces NULL a dereference.
> > 
> 
> I cant find this commit in known trees. Could you give the real commit
> id and its title ?
[...]

It's your commit 33eb9873a283a2076f2b5628813d5365ca420ea9, applied to
2.6.39.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

