Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab0LULXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 06:23:10 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:60891 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab0LULXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 06:23:08 -0500
Date: Tue, 21 Dec 2010 22:22:59 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: fix af_alg memory_allocated data type
Message-ID: <20101221112259.GA26409@gondor.apana.org.au>
References: <20101216173745.264eb2ca.sfr@canb.auug.org.au> <20101216101800.36529e89.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101216101800.36529e89.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 10:18:00AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Change data type to fix warning:
> 
> crypto/af_alg.c:35: warning: initialization from incompatible pointer type
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied.  Thanks Randy!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
