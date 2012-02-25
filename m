Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2BYHbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 02:31:09 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:1743 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469Ab2BYHbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 02:31:08 -0500
X-IronPort-AV: E=Sophos;i="4.73,480,1325458800"; 
   d="scan'208";a="145897036"
Date: Sat, 25 Feb 2012 08:31:04 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Michal Marek <mmarek@suse.cz>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Julia Lawall <julia@diku.dk>,
        kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, bruce.w.allan@intel.com, joe@perches.com,
        rusty@rustcorp.com.au
Subject: Re: [PATCH v3] scripts/coccinelle/misc/boolinit.cocci: semantic
 patch for bool issues
In-Reply-To: <20120224231153.GE19992@sepie.suse.cz>
Message-ID: <alpine.DEB.2.02.1202250830420.2007@hadrien>
References: <1328907918-31335-1-git-send-email-Julia.Lawall@lip6.fr> <20120224231153.GE19992@sepie.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 25 Feb 2012, Michal Marek wrote:

> On Fri, Feb 10, 2012 at 10:05:18PM +0100, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>> ERROR's changed to WARNING, except in assignment to non-0/1 case.
>
> Applied to kbuild.git#misc.

Thanks!

julia
