Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0ETJzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:55:21 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:38122 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752865Ab0ETJzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:55:19 -0400
Date: Thu, 20 May 2010 19:55:15 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Linux Mailing List <linux-kernel@vger.kernel.org>,
       Steven Liu <lingjiujianke@gmail.com>
Subject: Re: [PATCH] random: simplify fips mode
Message-ID: <20100520095515.GA11455@gondor.apana.org.au>
References: <1274334257.11603.1438.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274334257.11603.1438.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 12:44:17AM -0500, Matt Mackall wrote:
> Rather than dynamically allocate 10 bytes, move it to static allocation.
> This saves space and avoids the need for error checking.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
