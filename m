Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0ETF7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 01:59:22 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:62139 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab0ETF7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 01:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=j2qH8Ttik23hQqIim23/iVt0wFTVxdUrBx79Rc6xz7BRHLKxXPkrRlQH92X2AvFvlr
         5tmCf0q98ojsc39ugpvn+gjvLipHh4pRyp4R7q4uY5sDis1Rsu3LxuaQQAGiqgffV/+d
         qjNy1YuGqEMjOAz/kdVhbMxmeD65V++S6BxHA=
MIME-Version: 1.0
In-Reply-To: <1274325703-11092-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1274325703-11092-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> 
	<1274325703-11092-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 20 May 2010 01:58:58 -0400
Message-ID: <AANLkTilgJQ3MU-0cs9FF3OqZmyuY3KoAgNyMfBzK8hyz@mail.gmail.com>
Subject: Re: [PATCH -mm 1/6] blackfin: set ARCH_KMALLOC_MINALIGN
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       davem@davemloft.net, dwmw2@infradead.org, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 23:21, FUJITA Tomonori wrote:
> Architectures that handle DMA-non-coherent memory need to set
> ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe:
> the buffer doesn't share a cache with the others.

thanks, ive merged this into my tree and will push for 2.6.35
-mike
