Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab0I0ElO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 00:41:14 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:57854 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0I0ElN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 00:41:13 -0400
Date: Mon, 27 Sep 2010 12:41:00 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the crypto tree with the omap tree
Message-ID: <20100927044100.GA30155@gondor.apana.org.au>
References: <20100927143300.9fa73063.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927143300.9fa73063.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 02:33:00PM +1000, Stephen Rothwell wrote:
> Hi Herbert,
> 
> Today's linux-next merge of the crypto tree got a conflict in
> arch/arm/mach-omap2/devices.c between commit
> 5d14f2792f9d63c5d25903bd048017c4b53c7d9a ("omap: crypto: updates to
> enable omap aes") from the omap tree and commit
> b744c679f62b368cb94c21c1dcd4618e42d88d63 ("crypto: updates to enable omap
> aes") from the crypto tree.
> 
> Two versions of the same patch.  The version in the omap tree has been
> updated, so I used that.

Thanks for the note Stephen.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
