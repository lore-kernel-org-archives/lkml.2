Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1JZAmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 20:42:11 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:49039 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754074Ab1JZAmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 20:42:10 -0400
Message-ID: <4EA75759.3050900@xenotime.net>
Date: Tue, 25 Oct 2011 17:42:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 25 (crypto)
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
In-Reply-To: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/11 02:36, Stephen Rothwell wrote:
> Hi all,


When CONFIG_NET is not enabled:

ERROR: "nla_put" [crypto/rng.ko] undefined!
ERROR: "nla_put" [crypto/pcompress.ko] undefined!
ERROR: "netlink_kernel_release" [crypto/crypto_user.ko] undefined!
ERROR: "netlink_kernel_create" [crypto/crypto_user.ko] undefined!
ERROR: "init_net" [crypto/crypto_user.ko] undefined!
ERROR: "netlink_unicast" [crypto/crypto_user.ko] undefined!
ERROR: "__alloc_skb" [crypto/crypto_user.ko] undefined!
ERROR: "skb_trim" [crypto/crypto_user.ko] undefined!
ERROR: "skb_put" [crypto/crypto_user.ko] undefined!
ERROR: "netlink_dump_start" [crypto/crypto_user.ko] undefined!
ERROR: "nla_put" [crypto/crypto_user.ko] undefined!
ERROR: "netlink_rcv_skb" [crypto/crypto_user.ko] undefined!
ERROR: "nla_put" [crypto/crypto_hash.ko] undefined!
ERROR: "nla_put" [crypto/crypto_blkcipher.ko] undefined!
ERROR: "nla_put" [crypto/aead.ko] undefined!


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
