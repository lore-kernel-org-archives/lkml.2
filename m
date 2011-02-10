Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1BJSsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:48:37 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23541 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1BJSsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:48:35 -0500
Date: Thu, 10 Feb 2011 19:47:26 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Herbert Xu <herbert@gondor.hengli.com.au>
cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, aidan.o.mahony@intel.com,
        gabriele.paoloni@intel.com, adrian.hoban@intel.com
Subject: Re: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
In-Reply-To: <20110207210901.GA21941@gondor.apana.org.au>
Message-ID: <alpine.LNX.2.00.1102101945580.26035@swampdragon.chaosbits.net>
References: <4d502ccb.p+rKcuFjWCnBlXY9%tadeusz.struk@intel.com> <20110207210901.GA21941@gondor.apana.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Herbert Xu wrote:

> On Mon, Feb 07, 2011 at 05:32:59PM +0000, tadeusz.struk@intel.com wrote:
> >
> > Here goes.
> > 
> > Fix up previous patch that attempted to fix a mem leak in 
> > rfc4106_set_hash_subkey. The previous patch was flawed in that the 'goto 
> > out' would still leak.
> 
> Sign-off?
> 

Since it's identical to the patch I posted except for the moving of the 
kfree() which (IMHO) is a minor detail, I hope you can use my sign-off so 
we can move along and get the patch merged..

Signed-off-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

