Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab1AWIAO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 03:00:14 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:44216 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab1AWIAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 03:00:13 -0500
Date: Sun, 23 Jan 2011 19:00:06 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCHv2] hwrng: add support for picoxcell TRNG
Message-ID: <20110123080006.GB19175@gondor.apana.org.au>
References: <20110114181609.GN2822@pulham.picochip.com> <1295030661-16364-1-git-send-email-jamie@jamieiles.com> <20110115004416.GA19686@gondor.apana.org.au> <20110117102330.GB2622@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110117102330.GB2622@pulham.picochip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 10:23:30AM +0000, Jamie Iles wrote:
>
> Ok, that's a fair point!  Here's an updated version with a timeout.  
> I've also added in support for the fault detection which I previously 
> overlooked.

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
