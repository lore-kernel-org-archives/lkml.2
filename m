Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab2BJUT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:19:58 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:33524
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932337Ab2BJUT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:19:56 -0500
X-IronPort-AV: E=Sophos;i="4.73,398,1325458800"; 
   d="scan'208";a="130927051"
Date: Fri, 10 Feb 2012 21:19:53 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Julia Lawall <julia@diku.dk>,
        Michal Marek <mmarek@suse.cz>, Gilles Muller <Gilles.Muller@lip6.fr>,
        bruce.w.allan@intel.com, rusty@rustcorp.com.au,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        cocci@diku.dk, joe@perches.com
Subject: Re: [Cocci] [PATCH] scripts/coccinelle/misc/boolinit.cocci: semantic
 patch for bool issues
In-Reply-To: <1328900668.22240.100.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.02.1202102119400.1967@hadrien>
References: <1328893887-28932-1-git-send-email-Julia.Lawall@lip6.fr> <1328900668.22240.100.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Feb 2012, Artem Bityutskiy wrote:

> On Fri, 2012-02-10 at 18:11 +0100, Julia Lawall wrote:
>> +coccilib.report.print_report(p[0],"ERROR: Comparison of bool to 0/1")
>
> All of these look more like style/taste/hygiene suggestions, and I think
> they should be tagged as "WARNING", not "ERROR".

OK, I'll fix that.

julia
