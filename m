Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417Ab0JSMw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 08:52:56 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:47395 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0JSMwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 08:52:55 -0400
Date: Tue, 19 Oct 2010 20:52:50 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tracey Dent <tdent48227@gmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/02] Drivers: crypto: Makefile: replace the use of
	<module>-objs with <module>-y
Message-ID: <20101019125250.GC12898@gondor.apana.org.au>
References: <1287236963-1705-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287236963-1705-1-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 09:49:22AM -0400, Tracey Dent wrote:
> Changed <module>-objs to <module>-y in Makefile.
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>

I've rolled both patches into one and applied it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
