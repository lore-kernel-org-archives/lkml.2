Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1ATVan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:30:43 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56095 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab1ATVal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:30:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fuTKUqFjVssxYKbUrfpM9p73WgdDKu11yACbgqUoy18JacyXdk2n2u19ae1A3ZlSXl
         XVFMkRO2C/6b1LI6INVMMJjfAs5NgeOGDM71BvVn3Ty+RNvXx3ZJ9Q0+UxWtApKM8AxU
         agq4VcdGZFvjMVf7fvlxM7QAPasf2fbyrnmmI=
Subject: Re: [GIT] Networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1295558748.2613.28.camel@edumazet-laptop>
References: <20110119.180418.216749267.davem@davemloft.net>
	 <AANLkTin32jUnBtHF-EAkSMnFQM6cTbn-G3NZQJ3xjTWU@mail.gmail.com>
	 <1295558748.2613.28.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 22:30:36 +0100
Message-ID: <1295559036.2613.29.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 20 janvier 2011 à 22:25 +0100, Eric Dumazet a écrit :

> Do you know the type of socket ? UNIX or INET ?
> 
> You could try a revert of 2c6607c611cb7bf0a6750bcea3
> (net: add POLLPRI to sock_def_readable())
> 
> But I dont understand how it could hurt...
> 
> 
> 

Another candidate (AF_UNIX side) would be 973a34aa8593dbfe84386343c69
(af_unix: optimize unix_dgram_poll())

Thanks


