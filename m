Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237Ab2BJVFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:05:40 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:50409 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760158Ab2BJVFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:05:38 -0500
X-IronPort-AV: E=Sophos;i="4.73,398,1325458800"; 
   d="scan'208";a="143782818"
Date: Fri, 10 Feb 2012 22:05:36 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Julia Lawall <julia@diku.dk>,
        kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        bruce.w.allan@intel.com, joe@perches.com
Subject: Re: [PATCH v2] scripts/coccinelle/misc/boolinit.cocci: semantic
 patch for bool issues
In-Reply-To: <874nuye7aa.fsf@rustcorp.com.au>
Message-ID: <alpine.DEB.2.02.1202102205240.1967@hadrien>
References: <1328905355-30874-1-git-send-email-Julia.Lawall@lip6.fr> <874nuye7aa.fsf@rustcorp.com.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Feb 2012, Rusty Russell wrote:

> On Fri, 10 Feb 2012 21:22:35 +0100, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> FWIW:
> Reviewed-by: Rusty Russell <rusty@rustcorp.com.au>
>
>> +coccilib.report.print_report(p2[0],"WARNING: Assignment of bool to non-0/1 constant")
>
> IMHO, this one should be an error!

OK, I've changed that one.

julia
