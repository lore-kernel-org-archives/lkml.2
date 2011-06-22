Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1FVGXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:23:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16108 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1FVGXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:23:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=h5WIu8xdpwDdtm2bMF+k4+KxvWMWFfo8ugnbE6D2jnSS4OSjxBAVMgAsfpDng6jF4l
         c+natp5oZ82Z8hfQ2LRg==
Date: Tue, 21 Jun 2011 23:23:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cong Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/4] mm: completely disable THP by
 transparent_hugepage=0
In-Reply-To: <4E01816A.3040309@redhat.com>
Message-ID: <alpine.DEB.2.00.1106212322510.14693@chino.kir.corp.google.com>
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <alpine.DEB.2.00.1106211814250.5205@chino.kir.corp.google.com> <4E015CB8.1010300@redhat.com> <alpine.DEB.2.00.1106212010520.8712@chino.kir.corp.google.com> <4E01816A.3040309@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, Cong Wang wrote:

> > If you're proposing a patch for a specific purpose, it's appropriate to
> > include that in the changelog.
> 
> Sorry, I can't put everything you don't see into the changelog.
> 

As far as changelogs go, yes, we can demand that.

> > 
> > But now that I know what you're proposing this for, it's an easy NACK:
> > transparent_hugepage=0 has no significant benefit over
> > transparent_hugepage=never for kdump because the memory savings is
> > negligible.
> 
> I hate to repeat things, sorry, please go for the other thread where I
> replied to Andrea.
> 

All of this needs to be in the changelog if you want your patches to even 
be considered, thanks.
