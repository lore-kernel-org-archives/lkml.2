Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0GEK5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 06:57:13 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:53437 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab0GEK5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 06:57:08 -0400
Date: Mon, 5 Jul 2010 12:58:55 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <dan.kruchinin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 1/3] padata: separate serial and parallel cpumasks
Message-ID: <20100705105855.GL10072@secunet.com>
References: <AANLkTikeDE4hvZ3spyTBSHZsdQPc-2wlD5nTfb1aF-VD@mail.gmail.com>
 <20100702085323.GF10072@secunet.com>
 <AANLkTinyPGjXjlvJxB8WYB3EYFBtANXMzpTdUixyBRHW@mail.gmail.com>
 <20100702091726.GH10072@secunet.com>
 <AANLkTiltuZTkG5ZoG4TG9fA0anwRLFa__lHLnZpY2n4U@mail.gmail.com>
 <20100702111138.GI10072@secunet.com>
 <AANLkTil3pa-WKRKo3IQzgxkKc0I5qs5UPpgpiNiKlVBO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTil3pa-WKRKo3IQzgxkKc0I5qs5UPpgpiNiKlVBO@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 05 Jul 2010 10:57:03.0079 (UTC) FILETIME=[CCD63770:01CB1C30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 05:01:28PM +0400, Dan Kruchinin wrote:
> 
> Sounds good. But if I understand linux crypto framework right, it
> calls init_tfm every time it creates new security association. Ideally
> pcrypt should have only two cpumasks one for pencrypt instance and
> another for pdecrypt.
> If we'll initialize these cpumasks in pcrypt_alloc_tfm they'll be
> initialized every time new SA appears.

Yes, you are absolutely right. Placing this to instance context
is the right way to do it.

Thanks,

Steffen


