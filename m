Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1LNGrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 01:47:45 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44760 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157Ab1LNGrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 01:47:42 -0500
Date: Wed, 14 Dec 2011 08:47:36 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: "Alex,Shi" <alex.shi@intel.com>, David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 1/3] slub: set a criteria for slub node partial adding
In-Reply-To: <1323845054.2846.18.camel@edumazet-laptop>
Message-ID: <alpine.LFD.2.02.1112140846290.1841@tux.localdomain>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>  <alpine.DEB.2.00.1112020842280.10975@router.home>  <1323419402.16790.6105.camel@debian>  <alpine.DEB.2.00.1112090203370.12604@chino.kir.corp.google.com> 
 <6E3BC7F7C9A4BF4286DD4C043110F30B67236EED18@shsmsx502.ccr.corp.intel.com>  <alpine.DEB.2.00.1112131734070.8593@chino.kir.corp.google.com>  <alpine.DEB.2.00.1112131835100.31514@chino.kir.corp.google.com>  <1323842761.16790.8295.camel@debian>
 <1323845054.2846.18.camel@edumazet-laptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011, Eric Dumazet wrote:
> We should try to batch things a bit, instead of doing a very small unit
> of work in slow path.
>
> We now have a very fast fastpath, but inefficient slow path.
>
> SLAB has a litle cache per cpu, we could add one to SLUB for freed
> objects, not belonging to current slab. This could avoid all these
> activate/deactivate overhead.

Yeah, this is definitely worth looking at.

 			Pekka
