Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab0DIKdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 06:33:52 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:50688 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab0DIKdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 06:33:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=P20sH3IgBa2gdeZfn/0ztkX1UdG5LQRdLT5FXwnGb8upMZCgB9EXlvnT6sqH8LWCsl
         idSeYR39MgkMZSMYpyKE4V0j7OCefHS7Fk4MSz17aPjPC/qUwwl40oB9/dxN9S0EbYBz
         aqugFQPHgw+D4AfWqP2fNF758LEBgs4g75xBE=
MIME-Version: 1.0
In-Reply-To: <20100409101503.5051.3805.sendpatchset@localhost.localdomain>
References: <20100409101442.5051.99812.sendpatchset@localhost.localdomain> 
	<20100409101503.5051.3805.sendpatchset@localhost.localdomain>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 9 Apr 2010 18:33:29 +0800
Message-ID: <s2w412e6f7f1004090333g3b23eb94udb1e6cc3939a07e5@mail.gmail.com>
Subject: Re: [Patch 2/3] sysctl: add proc_do_large_bitmap
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Octavian Purdila <opurdila@ixiacom.com>,
       ebiederm@xmission.com, Eric Dumazet <eric.dumazet@gmail.com>,
       netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 9, 2010 at 6:11 PM, Amerigo Wang <amwang@redhat.com> wrote:
> From: Octavian Purdila <opurdila@ixiacom.com>
>
> The new function can be used to read/write large bitmaps via /proc. A
> comma separated range format is used for compact output and input
> (e.g. 1,3-4,10-10).
>
> Writing into the file will first reset the bitmap then update it
> based on the given input.
>

We have bitmap_scnprintf() and bitmap_parse_user(), why invent a new suite?


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
