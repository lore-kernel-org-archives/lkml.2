Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2DNUcm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 16:32:42 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20071 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab2DNUcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 16:32:41 -0400
Date: Sat, 14 Apr 2012 22:32:38 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: James Morris <jmorris@namei.org>
cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] mpi: Avoid using freed pointer in mpi_lshift_limbs()
In-Reply-To: <alpine.LRH.2.02.1204141048000.29204@tundra.namei.org>
Message-ID: <alpine.LNX.2.00.1204142231540.15578@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202062104440.20117@swampdragon.chaosbits.net> <alpine.LNX.2.00.1203012232480.19443@swampdragon.chaosbits.net> <CALLzPKbAGKL-o66UmWJ4uGSmA1TymdCQA0CfBajHLVYzt_60UA@mail.gmail.com> <alpine.LNX.2.00.1204120030130.2137@swampdragon.chaosbits.net>
 <CALLzPKY0Jd26gJTgcm5aXLZtzHJKqKVGXipBYtnzsisumnTR5A@mail.gmail.com> <alpine.LRH.2.02.1204141048000.29204@tundra.namei.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2046964595-1334435559=:15578"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2046964595-1334435559=:15578
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 14 Apr 2012, James Morris wrote:

> On Thu, 12 Apr 2012, Kasatkin, Dmitry wrote:
> 
> > >> >> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > >> >> ---
> > >> >>  lib/mpi/mpi-bit.c |    5 +++--
> > >> >>  1 files changed, 3 insertions(+), 2 deletions(-)
> > >> >>
> > >> >>  only compile tested.
> 
> > That is of course correct.
> > 
> > James, can you please apply this patch to security fixes?
> > 
> >  Acked-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> > 
> > - Dmitry
> 
> Has this patch been tested?
> 
Personally I don't really have a way to test it properly, so the only 
testing I've personally done is to check that it compiles.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-2046964595-1334435559=:15578--
