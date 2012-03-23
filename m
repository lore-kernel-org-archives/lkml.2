Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031623Ab2CWAmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 20:42:24 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:33199 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753416Ab2CWAmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 20:42:22 -0400
Date: Fri, 23 Mar 2012 08:42:10 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: camellia-x86_64 - module init/exit
	functions should be static
Message-ID: <20120323004209.GA20518@gondor.apana.org.au>
References: <4F620F37.4070404@xenotime.net> <20120315201151.11667.63183.stgit@localhost6.localdomain6> <4F6A74E3.7080901@xenotime.net> <20120322004646.GA8489@gondor.apana.org.au> <4F6B9709.1040701@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6B9709.1040701@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 02:18:01PM -0700, H. Peter Anvin wrote:
>
> > Thanks for the reminder, I'll push these through today.
> 
> Please push these to Linus ASAP, it is breaking the x86-64 allyesconfig
> build upstream right now.

I've pushed them through.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
