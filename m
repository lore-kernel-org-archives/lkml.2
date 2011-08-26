Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1HZFAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 01:00:54 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37453 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1HZFAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 01:00:51 -0400
Date: Fri, 26 Aug 2011 14:49:02 +1000
From: David Gibson <dwg@au1.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: jdl@jdl.com, John Bonesio <bones@secretlab.ca>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dtc: remove some warnings
Message-ID: <20110826044902.GJ2308@yookeroo.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, jdl@jdl.com,
	John Bonesio <bones@secretlab.ca>,
	ppc-dev <linuxppc-dev@lists.ozlabs.org>,
	linux-kernel@vger.kernel.org
References: <20110826112643.f86132d55edc5d452df3ebd0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826112643.f86132d55edc5d452df3ebd0@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 11:26:43AM +1000, Stephen Rothwell wrote:
> I assume that these variables were used in the past but not removed when
> their usage was removed.
> 
> Fixes these warnings:
> 
> scripts/dtc/dtc.c: In function 'main':
> scripts/dtc/dtc.c:102:17: warning: variable 'check' set but not used [-Wunused-but-set-variable]
> scripts/dtc/flattree.c: In function 'flat_read_mem_reserve':
> scripts/dtc/flattree.c:700:14: warning: variable 'p' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: David Gibson <david@gibson.dropbear.id.au>

Yeah, I noticed these gcc 4.6 warnings recently, but didn't get around
to sending a patch.

Jon, please apply.  Uh.. except that this is a patch against the in
kernel dtc, rather than upstream.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
