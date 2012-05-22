Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab2EVMJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:09:31 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9366 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2EVMJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:09:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 22 May 2012 05:08:04 -0700
Date: Tue, 22 May 2012 15:08:52 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
CC: "Turquette, Mike" <mturquette@ti.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Clock register in early init
Message-ID: <20120522120851.GI8730@tbergstrom-lnx.Nvidia.com>
References: <1337227884.2066.9.camel@pgaikwad-dt2>
 <20120517062131.GA9305@gmail.com>
 <1337316517.22560.19.camel@pgaikwad-dt2>
 <20120518112104.GL20304@tbergstrom-lnx.Nvidia.com>
 <CAJOA=zM_o1Nqw55xxFvw6KssM50Q+7yyo41rUSH2Aoo1neTMjg@mail.gmail.com>
 <20120521084642.GV20304@tbergstrom-lnx.Nvidia.com>
 <4FBB5A72.2080101@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FBB5A72.2080101@codethink.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We had at-least that on the older Samsung parts and they where still
> growing. I would suggest that in a multi-kernel image situation the
> more data that can be discarded after init-time the better.
> 
> Also, __initdata gets gathered into one place so there's no possibility
> of page fragmentation there. If you mean fragmentation of the memory
> map, then allocate the size of all the clocks you know of at init time
> in one go.
> 

That would work, except that clocks are needed before kmalloc is available.

Cheers,

Peter.
