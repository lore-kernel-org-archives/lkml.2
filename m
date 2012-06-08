Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761797Ab2FHFMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:12:35 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:55931
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761774Ab2FHFMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:12:32 -0400
X-IronPort-AV: E=Sophos;i="4.75,734,1330902000"; 
   d="scan'208";a="146977945"
Date: Fri, 8 Jun 2012 07:12:18 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: David Miller <davem@davemloft.net>
cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, julia@diku.dk
Subject: Re: [PATCH 1/7] drivers/ide/ide-cs.c: adjust suspicious bit
 operation
In-Reply-To: <20120607.144616.2224976714259476349.davem@davemloft.net>
Message-ID: <alpine.DEB.2.02.1206080711370.1793@hadrien>
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr> <1339018901-28439-2-git-send-email-Julia.Lawall@lip6.fr> <20120607.144616.2224976714259476349.davem@davemloft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2012, David Miller wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> Date: Wed,  6 Jun 2012 23:41:35 +0200
>
>> -	if (!(pdev->resource[0]->flags & IO_DATA_PATH_WIDTH_8)) {
>> +	if ((p1dev->resource[0]->flags & IO_DATA_PATH_WIDTH)
>
> I'm really surprised someone as thorough as yourself did not
> compile test this.

Sorry, I changed the patch at the last minute, and it was indeed not a 
good idea not to have compiled again.  I will send another version, in 
case it is useful.

julia
