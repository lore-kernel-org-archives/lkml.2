Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab0GNXtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:49:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:45642 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0GNXtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:49:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ukiS7QMfWlQq10lk+V8JO3ndaOx1UBgGgD2hrHjBoaF3738kvDNZoZEoTMMI1Sj9k
	reW57XLm6eGAuJXlJAHMg==
Date: Wed, 14 Jul 2010 16:48:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q2 07/19] slub: Allow removal of slab caches during boot
In-Reply-To: <20100709190853.770833931@quilx.com>
Message-ID: <alpine.DEB.2.00.1007141647340.29110@chino.kir.corp.google.com>
References: <20100709190706.938177313@quilx.com> <20100709190853.770833931@quilx.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010, Christoph Lameter wrote:

> If a slab cache is removed before we have setup sysfs then simply skip over
> the sysfs handling.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Roland Dreier <rdreier@cisco.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Acked-by: David Rientjes <rientjes@google.com>

I missed this case earlier because I didn't consider slab caches being 
created and destroyed prior to slab_state == SYSFS, sorry!
