Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0K2X1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:27:36 -0500
Received: from ozlabs.org ([203.10.76.45]:42477 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab0K2X1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:27:34 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/2] The new jhash implementation
Date: Sat, 27 Nov 2010 14:01:22 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic-pae; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
References: <1290690908-794-1-git-send-email-kadlec@blackhole.kfki.hu> <1290690908-794-2-git-send-email-kadlec@blackhole.kfki.hu> <1290690908-794-3-git-send-email-kadlec@blackhole.kfki.hu>
In-Reply-To: <1290690908-794-3-git-send-email-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011271401.22773.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010 11:45:08 pm Jozsef Kadlecsik wrote:
> The current jhash.h implements the lookup2() hash function by Bob Jenkins.
> However, lookup2() is outdated as Bob wrote a new hash function called
> lookup3(). The new hash function

Oops, we discussed this ages ago, looks like it fell through the cracks.

Thanks Jozsef!

> +extern u32 jhash(const void *key, u32 length, u32 initval);
> +extern u32 jhash2(const u32 *k, u32 length, u32 initval);
> +extern u32 jhash_3words(u32 a, u32 b, u32 c, u32 initval);

This last one can be marked __attribute__((const)) for a little
extra compiler help, too.

Cheers,
Rusty.
