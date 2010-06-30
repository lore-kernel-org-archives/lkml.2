Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab0F3UHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:07:41 -0400
Received: from smtp-out.google.com ([74.125.121.35]:21674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab0F3UHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:07:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=TXimUIh+JhilarsOI0Kz1O1X5VmZk0Dwhnziuosf5dDEq8owW6Vgigv89JteDvjy9
	oimTMxQ2iXVuACkYUdFgg==
Date: Wed, 30 Jun 2010 13:07:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xiaotian Feng <dfeng@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH V2] slab: fix caller tracking on !CONFIG_DEBUG_SLAB &&
 CONFIG_TRACING
In-Reply-To: <1277891842-18898-1-git-send-email-dfeng@redhat.com>
Message-ID: <alpine.DEB.2.00.1006301307001.27676@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1004090947030.10992@chino.kir.corp.google.com> <1277891842-18898-1-git-send-email-dfeng@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, Xiaotian Feng wrote:

> In slab, all __xxx_track_caller is defined on CONFIG_DEBUG_SLAB || CONFIG_TRACING,
> thus caller tracking function should be worked for CONFIG_TRACING. But if
> CONFIG_DEBUG_SLAB is not set, include/linux/slab.h will define xxx_track_caller to
> __xxx() without consideration of CONFIG_TRACING. This will break the caller tracking
> behaviour then.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Vegard Nossum <vegard.nossum@gmail.com>
> Cc: Dmitry Monakhov <dmonakhov@openvz.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>
