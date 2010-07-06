Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0GFHA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:00:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62640 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab0GFHA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:00:27 -0400
MIME-Version: 1.0
In-Reply-To: <20100705.192221.241453945.davem@davemloft.net>
References: <20100629193618.5a840b8e@dev.queued.net> <AANLkTilme2uAoXjorUEzam9j_xosR8kl70W8PS71d-Th@mail.gmail.com> 
	<20100707040734.05d625af@debxo> <20100705.192221.241453945.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 6 Jul 2010 01:00:06 -0600
X-Google-Sender-Auth: B2yQxP47JTFvnld-b5w3KHRR-WM
Message-ID: <AANLkTil3aZ0IF1KEc2h9MLHPZYW23pnWzEy4IiVb3zxT@mail.gmail.com>
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building code 
	out into drivers/of
To: David Miller <davem@davemloft.net>
Cc: dilinger@queued.net, devicetree-discuss@lists.ozlabs.org,
       sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, cjb@laptop.org, wmb@laptop.org,
       pgf@laptop.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 5, 2010 at 8:22 PM, David Miller <davem@davemloft.net> wrote:
> From: Andres Salomon <dilinger@queued.net>
> Date: Wed, 7 Jul 2010 04:07:34 +0000
>
>>  - For the pdt, calling into the prom once for each property/node to
>>    create a fdt, and then unflattening it.  This is better than the
>>    previous option, but I don't think the prom->fdt code will be very
>>    nice.
>
> I'll need this on sparc64 at some point to support kexec() anyways.
>
> So at least for sparc you can assume that a something-->fdt translator
> is going to exist at some point in the future regardless of what
> happens here.

Hi David,

I'm curious... what are your plans here?  Will you be keeping OF alive
between kexec()?  Will the new kernel get the entire device tree from
fdt, or will it still be talking to OF?  How will the fdt fragments as
Andres described above fit into sparc kexec (as opposed to generating
one big tree as in his first option)?

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
