Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab1FVBR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 21:17:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:36083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab1FVBR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 21:17:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=u0aMY7dq26izPbIct6u9qI5/NB7HuIw1fEQUBx37wJkJWEK0xFDireh75VTXXsAEKA
         gc8/vvn2Glsf3vSXueaQ==
Date: Tue, 21 Jun 2011 18:16:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Amerigo Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/4] mm: completely disable THP by
 transparent_hugepage=0
In-Reply-To: <1308643849-3325-1-git-send-email-amwang@redhat.com>
Message-ID: <alpine.DEB.2.00.1106211814250.5205@chino.kir.corp.google.com>
References: <1308643849-3325-1-git-send-email-amwang@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Wed, 22 Jun 2011 01:17:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011, Amerigo Wang wrote:

> Introduce "transparent_hugepage=0" to totally disable THP.
> "transparent_hugepage=never" means setting THP to be partially
> disabled, we need a new way to totally disable it.
> 

Why can't you just compile it off so you never even compile 
mm/huge_memory.c in the first place and save the space in the kernel image 
as well?  Having the interface available to enable the feature at runtime 
is worth the savings this patch provides, in my opinion.
