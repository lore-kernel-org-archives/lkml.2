Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab0GNWRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:17:03 -0400
Received: from smtp-out.google.com ([74.125.121.35]:18942 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab0GNWRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:17:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=NNM0WfhSpcWL5g3gPsxy6AKpCeZic4iZWNGJykX5JPVKjDA4xka8/3rbMyFYZUiQ8
	BFB+JkKi1swx5J8G0wcGg==
Date: Wed, 14 Jul 2010 15:16:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q2 06/19] slub: Check kasprintf results in
 kmem_cache_init()
In-Reply-To: <20100709190853.195193717@quilx.com>
Message-ID: <alpine.DEB.2.00.1007141515560.17291@chino.kir.corp.google.com>
References: <20100709190706.938177313@quilx.com> <20100709190853.195193717@quilx.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010, Christoph Lameter wrote:

> Small allocations may fail during slab bringup which is fatal. Add a BUG_ON()
> so that we fail immediately rather than failing later during sysfs
> processing.
> 
> CC: David Rientjes <rientjes@google.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Acked-by: David Rientjes <rientjes@google.com>
