Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1BFUfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:35:51 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22084 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1BFUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:35:49 -0500
Date: Sun, 6 Feb 2011 21:34:33 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Herbert Xu <herbert@gondor.hengli.com.au>
cc: "Struk, Tadeusz" <tadeusz.struk@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>,
        "Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>
Subject: Re: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
In-Reply-To: <20110206203408.GA12426@gondor.apana.org.au>
Message-ID: <alpine.LNX.2.00.1102062134150.13593@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101161527440.8049@swampdragon.chaosbits.net> <24483BA4C9F69C43A7379639D35543D7C5398DB6@irsmsx502.ger.corp.intel.com> <alpine.LNX.2.00.1102062039080.13593@swampdragon.chaosbits.net> <20110206203408.GA12426@gondor.apana.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, Herbert Xu wrote:

> On Sun, Feb 06, 2011 at 08:43:22PM +0100, Jesper Juhl wrote:
> > 
> > Herbert: If Tadeusz agrees, could you please replace the patch you merged 
> > with the one above?
> 
> Please send an incremental patch.
> 
Sure thing. What would you like it based on exactly?

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

