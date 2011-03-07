Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab1CGJ7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 04:59:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab1CGJ7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 04:59:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Kaiser <nikai@nikai.net>
Subject: Re: [PATCH] drivers/net/macvtap: fix error check
Date: Mon, 7 Mar 2011 10:59:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20110305004941.7b195e9d@absol.kitzblitz>
In-Reply-To: <20110305004941.7b195e9d@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103071059.04321.arnd@arndb.de>
X-Provags-ID: V02:K0:rVZNKy9FI45lGH+9rI+8TXir7rPBjM6AmzCvSyzAhxu
 pENOdpRRUsVwaiqIAp2/aGj9kCCQBYcD4hebiROkW7yP9gkkov
 NZ/Jb3FC4mVkFD7k3qE8Ln7OAlMUJa/zQwkXAYTxAv4IFXu191
 Q9wrORb9QODGpVg1T3sTPnnQpwcNkCewdNeCSjw4lzZRC5Vnom
 EPitYs4d41Aoy+PUgGPBg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 March 2011, Nicolas Kaiser wrote:
> 'len' is unsigned of type size_t and can't be negative.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I think it's harmless: the worst thing that can happen is
macvtap_alloc_skb() failing with ENOMEM when it gets a
large argument, but we could have it in -stable just to
be sure.

	Arnd
