Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab2DNAse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 20:48:34 -0400
Received: from tundra.namei.org ([65.99.196.166]:54755 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437Ab2DNAsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 20:48:33 -0400
Date: Sat, 14 Apr 2012 10:48:26 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] mpi: Avoid using freed pointer in mpi_lshift_limbs()
In-Reply-To: <CALLzPKY0Jd26gJTgcm5aXLZtzHJKqKVGXipBYtnzsisumnTR5A@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1204141048000.29204@tundra.namei.org>
References: <alpine.LNX.2.00.1202062104440.20117@swampdragon.chaosbits.net> <alpine.LNX.2.00.1203012232480.19443@swampdragon.chaosbits.net> <CALLzPKbAGKL-o66UmWJ4uGSmA1TymdCQA0CfBajHLVYzt_60UA@mail.gmail.com> <alpine.LNX.2.00.1204120030130.2137@swampdragon.chaosbits.net>
 <CALLzPKY0Jd26gJTgcm5aXLZtzHJKqKVGXipBYtnzsisumnTR5A@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1665246916-431020138-1334364506=:29204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-431020138-1334364506=:29204
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 12 Apr 2012, Kasatkin, Dmitry wrote:

> >> >> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> >> >> ---
> >> >>  lib/mpi/mpi-bit.c |    5 +++--
> >> >>  1 files changed, 3 insertions(+), 2 deletions(-)
> >> >>
> >> >>  only compile tested.

> That is of course correct.
> 
> James, can you please apply this patch to security fixes?
> 
>  Acked-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> 
> - Dmitry

Has this patch been tested?



-- 
James Morris
<jmorris@namei.org>
--1665246916-431020138-1334364506=:29204--
