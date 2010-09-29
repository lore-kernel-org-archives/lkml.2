Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab0I2UZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 16:25:34 -0400
Received: from smtp-out.google.com ([74.125.121.35]:7766 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab0I2UZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 16:25:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=R5dOdOPBvlukxvZKEFhNc3Fw1Vbko81An5Me+FnMSckWrNz+W7Gy65+11R5X4ejIw
	G+E0+HBM0Xymn22gvmVVQ==
Date: Wed, 29 Sep 2010 13:25:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Namhyung Kim <namhyung@gmail.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] slub: Move NUMA-related functions under
 CONFIG_NUMA
In-Reply-To: <1285761735-31499-3-git-send-email-namhyung@gmail.com>
Message-ID: <alpine.DEB.2.00.1009291324500.9797@chino.kir.corp.google.com>
References: <1285761735-31499-1-git-send-email-namhyung@gmail.com> <1285761735-31499-3-git-send-email-namhyung@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010, Namhyung Kim wrote:

> Make kmalloc_cache_alloc_node_notrace(), kmalloc_large_node()
> and __kmalloc_node_track_caller() to be compiled only when
> CONFIG_NUMA is selected.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
