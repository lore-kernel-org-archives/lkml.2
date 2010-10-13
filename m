Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab0JMGbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 02:31:17 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54454 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0JMGbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 02:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=EkhrfykzcvJl6r+nF1jw8zDr5S0bPO5+jDvPHhbfchWGUY2xLJiPZexKccvDLL/2zf
         sb7C3WNmx4cCkKkmD+6w==
Date: Tue, 12 Oct 2010 23:31:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH net-next] net:  allocate skbs on local node
In-Reply-To: <4CB54EE8.4020707@kernel.org>
Message-ID: <alpine.DEB.2.00.1010122330090.13748@chino.kir.corp.google.com>
References: <1286838210.30423.128.camel@edumazet-laptop> <1286839363.30423.130.camel@edumazet-laptop> <1286859925.30423.184.camel@edumazet-laptop> <20101011230322.f0f6dd47.akpm@linux-foundation.org> <1286866699.30423.234.camel@edumazet-laptop>
 <20101012002435.f51f2c0e.akpm@linux-foundation.org> <1286869793.2732.24.camel@edumazet-laptop> <20101012005856.994bea6d.akpm@linux-foundation.org> <4CB441CB.2000708@cs.helsinki.fi> <alpine.DEB.2.00.1010120745360.31832@router.home>
 <alpine.DEB.2.00.1010121234380.10165@chino.kir.corp.google.com> <4CB54EE8.4020707@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010, Pekka Enberg wrote:

> I think Christoph is saying that we'd remove SLAB and make the unified
> allocator the new SLAB while keeping SLUB in place.

Right, so his unification patches would be against slab instead of slub 
which is a pretty major change from the current state of the patchset, 
although it might actually be smaller?
