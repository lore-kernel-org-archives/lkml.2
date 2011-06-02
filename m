Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab1FBRML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 13:12:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:25706 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1FBRMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 13:12:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=sB+0f7AzKFS+GBvo1eD9pZs3AhNu0G0oLdzQ3tQjSFp/j6eCOC/C+Eizf2q3cECUAD
         cW8EPNuqi0ReoeIVVfeA==
Date: Thu, 2 Jun 2011 10:12:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Suleiman Souhlal <ssouhlal@freebsd.org>
cc: penberg@kernel.org, suleiman@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cl@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] SLAB: Record actual last user of freed objects.
In-Reply-To: <1306999002-29738-1-git-send-email-ssouhlal@FreeBSD.org>
Message-ID: <alpine.DEB.2.00.1106021011510.18350@chino.kir.corp.google.com>
References: <1306999002-29738-1-git-send-email-ssouhlal@FreeBSD.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jun 2011, Suleiman Souhlal wrote:

> Currently, when using CONFIG_DEBUG_SLAB, we put in kfree() or
> kmem_cache_free() as the last user of free objects, which is not
> very useful, so change it to the caller of those functions instead.
> 
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>

Acked-by: David Rientjes <rientjes@google.com>
