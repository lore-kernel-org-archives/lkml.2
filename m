Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab2AXTyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:54:49 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:32872 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938Ab2AXTys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:54:48 -0500
Date: Tue, 24 Jan 2012 21:54:38 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Christoph Lameter <cl@linux.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, "Alex,Shi" <alex.shi@intel.com>,
        Shaohua Li <shaohua.li@intel.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] slub: prefetch next freelist pointer in slab_alloc()
In-Reply-To: <alpine.DEB.2.00.1112161030270.26651@router.home>
Message-ID: <alpine.LFD.2.02.1201242152480.1658@tux.localdomain>
References: <1324049134.25554.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1112161030270.26651@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011, Eric Dumazet wrote:
>> Recycling a page is a problem, since freelist link chain is hot on
>> cpu(s) which freed objects, and possibly very cold on cpu currently
>> owning slab.

On Fri, 16 Dec 2011, Christoph Lameter wrote:
> Good idea. How do the tcp benchmarks look after this?
>
> Looks sane.
>
> Acked-by: Christoph Lameter <cl@linux.com>

Applied, thanks!
