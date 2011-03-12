Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1CLBGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 20:06:04 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:39678 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1CLBGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 20:06:03 -0500
Date: Sat, 12 Mar 2011 09:05:52 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Andi Kleen <ak@linux.intel.com>
Cc: Milan Broz <mbroz@redhat.com>,
        "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-crypt: Performance Regression 2.6.37 -> 2.6.38-rc8
Message-ID: <20110312010552.GA28515@gondor.apana.org.au>
References: <20110308164508.GA8729@darkside.kls.lan> <20110310165730.GC20504@alboin.amr.corp.intel.com> <20110310175411.GB25027@darkside.kls.lan> <20110311011842.GA5698@alboin.amr.corp.intel.com> <20110311180334.GA11382@darkside.kls.lan> <4D7A6A26.5000501@redhat.com> <20110311183654.GA3272@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311183654.GA3272@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 10:36:54AM -0800, Andi Kleen wrote:
>
> It needs some glue according to Herbert. I forgot the details.

As we don't want to have pcrypt default on it needs to be loaded
by hand.  What we lack is a clean way to instantiate it.

For now you have to do something like

modprobe tcrypt alg="pcrypt(authenc(hmac(sha1-generic),cbc(aes-asm)))" type=3

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
