Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0JHVeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 17:34:18 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:39400 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab0JHVeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 17:34:17 -0400
Date: Fri, 8 Oct 2010 14:34:50 -0700
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] sparc: stop exporting openprom.h header
Message-ID: <20101008143450.1334d8df@debxo>
In-Reply-To: <AANLkTikuaM5VZadCs302HwYYhOHi1Czw2BLam3ZQP=aj@mail.gmail.com>
References: <20101008173650.GH3863@angua.secretlab.ca>
	<20101008.104557.59696706.davem@davemloft.net>
	<20101008113424.2249c2df@debxo>
	<20101008.115226.179923658.davem@davemloft.net>
	<AANLkTikuaM5VZadCs302HwYYhOHi1Czw2BLam3ZQP=aj@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010 13:00:25 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Fri, Oct 8, 2010 at 12:52 PM, David Miller <davem@davemloft.net>
> wrote:
> > From: Andres Salomon <dilinger@queued.net>
> > Date: Fri, 8 Oct 2010 11:34:24 -0700
> >
> >>
> >> It's unknown why openprom.h was being exported; there doesn't seem
> >> to be any reason for it currently, and it creates headaches with
> >> userspace being able to potentially use the structures in there.
> >>  So, don't export it anymore.
> >>
> >> Signed-off-by: Andres Salomon <dilinger@queued.net>
> >
> > Acked-by: David S. Miller <davem@davemloft.net>
> 
> I suppose it makes sense for me to pick this one up into my tree so it
> is grouped with the rest of the pdt patches.  I'll pick it up once
> Andres reposts the series.
> 
> g.

Ok, I sent a new version of the phandle stuff (which was easier than
expected, and doesn't affect any other patches).

So to summarize, what's pending is:

1- https://patchwork.kernel.org/patch/242041/ (sparc: stop exporting
   openprom.h header)
   Acked by Dave

2- https://patchwork.kernel.org/patch/242601/ ([v3] sparc: convert
   various prom_* functions to use phandle)
   Acked by Dave

3- https://patchwork.kernel.org/patch/141011/ (sparc: break out some
   PROM device-tree building code out into drivers/of)
   Acked by Dave

4- https://patchwork.kernel.org/patch/141021/ (sparc: make
   drivers/of/pdt.c no longer sparc-only)
   Acked by Dave

5- https://patchwork.kernel.org/patch/141031/ (of: no longer call prom_
   functions directly; use an ops structure)
   Acked by Dave

6- https://patchwork.kernel.org/patch/141041/ (of: add
   of_pdt namespace to pdt code)
   Acked by Dave

7- https://patchwork.kernel.org/patch/141051/ (of: add package-to-path
   support to pdt)

8- https://patchwork.kernel.org/patch/141071/ (x86: OLPC: add OLPC
   device-tree support)

The make-of-build-on-x86 stuff is already in your tree.
