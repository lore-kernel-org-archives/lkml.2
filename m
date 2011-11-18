Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab1KRMSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 07:18:44 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:57941 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1KRMSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 07:18:43 -0500
Date: Fri, 18 Nov 2011 20:18:32 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, evonlanthen@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        timo.teras@iki.fi
Subject: [0/6] Replace LL_ALLOCATED_SPACE to allow needed_headroom
	adjustment
Message-ID: <20111118121832.GA2868@gondor.apana.org.au>
References: <20111020.053050.383972361986316046.davem@davemloft.net> <20111020093541.GA3024@gondor.apana.org.au> <20111025115425.GA1530@gondor.apana.org.au> <20111025.231204.257472162924919077.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025.231204.257472162924919077.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 11:12:04PM -0400, David Miller wrote:
> From: Herbert Xu <herbert@gondor.hengli.com.au>
> Date: Tue, 25 Oct 2011 13:54:25 +0200
> 
> > So I'm going to get rid of LL_ALLOCATED_SPACE completely and
> > replace it with explicit references to the tailroom as it doesn't
> > need the alignment anyway (The headroom needs alignment since
> > we use it to ensure the head is aligned).
> 
> Ok.

Here are the patches that do this.  I also picked up one spot
that should have used LL_ALLOCATED_SPACE but did not (see 2nd
last patch).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
