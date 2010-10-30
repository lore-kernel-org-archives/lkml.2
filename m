Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab0J3VZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:25:41 -0400
Received: from ozlabs.org ([203.10.76.45]:45032 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab0J3VZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:25:38 -0400
From: Jeremy Kerr <jk@ozlabs.org>
To: cbe-oss-dev@lists.ozlabs.org
Subject: Re: [Cbe-oss-dev] [PATCH] PowerPC/Cell: use vzalloc rather than vmalloc and memset in spu_alloc_lscsa_std
Date: Sat, 30 Oct 2010 17:25:32 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Arnd Bergmann <arnd@arndb.de>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
References: <alpine.LNX.2.00.1010302004290.1572@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1010302004290.1572@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010301725.32559.jk@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper,

> We can get rid of a memset in
> arch/powerpc/platforms/cell/spufs/lscsa_alloc.c::spu_alloc_lscsa_std() by
> using vzalloc() rather than vmalloc()+memset().

Looks good to me.

Acked-By: Jeremy Kerr <jk@ozlabs.org>

Ben, could you apply this to the powerpc tree?

Cheers,


Jeremy
