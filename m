Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030488Ab2CVAq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 20:46:57 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:50594 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755406Ab2CVAqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 20:46:55 -0400
Date: Thu, 22 Mar 2012 11:46:46 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: camellia-x86_64 - module init/exit
	functions should be static
Message-ID: <20120322004646.GA8489@gondor.apana.org.au>
References: <4F620F37.4070404@xenotime.net> <20120315201151.11667.63183.stgit@localhost6.localdomain6> <4F6A74E3.7080901@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6A74E3.7080901@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 05:40:03PM -0700, Randy Dunlap wrote:
> On 03/15/2012 01:11 PM, Jussi Kivilinna wrote:
> 
> > This caused conflict with twofish-x86_64-3way when compiled into kernel,
> > same function names and not static.
> 
> Have these patches been merged anywhere?
> I'm still seeing build problems in linux-next 20120321.

Thanks for the reminder, I'll push these through today.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
