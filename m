Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024Ab1CXTzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:55:37 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38631 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832Ab1CXTze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vENgnzJzWUNIDXvdzhUWgp+mvjVBWmN6RpsTeX6HZJ3lbebriXCP5BSUuDAImnQDb5
         pmwfRAvoyFPZ1ii9eYvizIbu4FZ2/3wJ3zJ7MFw4qnZVXHtTTKrP7Uw2rs2HIwEbsAvM
         LhyrKkmcUakTXifyx9ZssLzOshKgJDX9M7zA0=
MIME-Version: 1.0
In-Reply-To: <20110323211346.9ae51356.akpm@linux-foundation.org>
References: <20110324143019.cce06baa.sfr@canb.auug.org.au>
	<20110323211346.9ae51356.akpm@linux-foundation.org>
Date: Thu, 24 Mar 2011 12:55:33 -0700
X-Google-Sender-Auth: 4OgGJc84ynXi9Jjmknmrbb-loTM
Message-ID: <AANLkTimx77O+cc_kVkTQOYxrCHetUcmiu6NE1Oz5_83o@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
From: Tony Luck <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 9:13 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Meanwhile, ddd588b5dd55f143203799 reverts cleanly and I'd suggest we do
> that.

I tried that revert (from Linus' tree this morning HEAD
=6c5103890057b1bb781b26b7aae38d33e4c517d8)
and got:


  CC      mm/page_alloc.o
mm/page_alloc.c: In function ‘__alloc_pages_slowpath’:
mm/page_alloc.c:2180: error: ‘SHOW_MEM_FILTER_NODES’ undeclared (first
use in this function)
mm/page_alloc.c:2180: error: (Each undeclared identifier is reported only once
mm/page_alloc.c:2180: error: for each function it appears in.)
mm/page_alloc.c:2198: error: implicit declaration of function ‘__show_mem’
make[1]: *** [mm/page_alloc.o] Error 1
make: *** [mm] Error 2

-Tony
