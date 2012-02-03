Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab2BCGYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 01:24:30 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:60144 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab2BCGY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 01:24:28 -0500
Date: Fri, 3 Feb 2012 07:24:25 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: "devendra.aaru" <devendra.aaru@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] In crypto_add_alg(), 'exact' wants to be initialized
 to 0
Message-ID: <20120203062425.GH23142@secunet.com>
References: <alpine.LNX.2.00.1201292337390.27749@swampdragon.chaosbits.net>
 <CAHdPZaP4aArSh7G15KhP2ombW8Zs2L4osQ0xi0W829oBZSuTtg@mail.gmail.com>
 <alpine.LNX.2.00.1202012050390.8577@swampdragon.chaosbits.net>
 <20120202075122.GA23142@secunet.com>
 <alpine.LNX.2.00.1202021541440.12088@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202021541440.12088@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 03 Feb 2012 06:24:25.0484 (UTC) FILETIME=[79B6CCC0:01CCE23C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 03:42:43PM +0100, Jesper Juhl wrote:
> On Thu, 2 Feb 2012, Steffen Klassert wrote:
> > 
> > Your first patch is correct.
> > 
> Thank you for the explanation.
> 
> Can I take that to mean that I can add your Acked-by: if/when I resend the 
> patch?
> 

Sure,

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
