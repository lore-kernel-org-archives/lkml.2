Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab0DGQ4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:56:10 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:49615 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab0DGQ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:56:08 -0400
Date: Wed, 7 Apr 2010 11:55:07 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] slab: Generify kernel pointer validation
In-Reply-To: <1270657421-1937-1-git-send-email-penberg@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1004071145070.13261@router.home>
References: <1270657421-1937-1-git-send-email-penberg@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010, Pekka Enberg wrote:

> +int kern_ptr_validate(const void *ptr, unsigned long size)
> +{
> +	unsigned long addr = (unsigned long)ptr;
> +	unsigned long min_addr = PAGE_OFFSET;

Use the min_addr from the security subsystem?

