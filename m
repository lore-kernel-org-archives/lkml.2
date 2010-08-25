Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab0HYXTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:19:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1384 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0HYXTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:19:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fy6EvqgiQoiYFKFhObgkfFJI4s+YGzlXmVAOmN+E6LA0HjtjlVU9z4fbJfX0lSRF2
	gyhyGfmSsLetMEmly5NLw==
Date: Wed, 25 Aug 2010 16:18:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: linux-next: Tree for August 25 (mm/slub)
In-Reply-To: <alpine.DEB.2.00.1008251405590.22117@router.home>
Message-ID: <alpine.DEB.2.00.1008251618400.31521@chino.kir.corp.google.com>
References: <20100825132057.c8416bef.sfr@canb.auug.org.au> <20100825094559.bc652afe.randy.dunlap@oracle.com> <alpine.DEB.2.00.1008251405590.22117@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Christoph Lameter wrote:

> Subject: slub: Add dummy functions for the !SLUB_DEBUG case
> 
> Provide the fall back functions to empty hooks if SLUB_DEBUG is not set.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: David Rientjes <rientjes@google.com>
