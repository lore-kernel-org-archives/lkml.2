Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1DNWAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:00:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:7665 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1DNWAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=R6g0TZvQfbYPfTbzn7EGUC/JxctO/vTpTqCz/19l3AugZETygCM9U8wwWeC2shmIyK
         YPx7tWOAjt9GWQS5bIfg==
Date: Thu, 14 Apr 2011 15:00:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 3/3] reuse __free_pages_exact() in
 __alloc_pages_exact()
In-Reply-To: <20110414200141.09C3AA5F@kernel>
Message-ID: <alpine.DEB.2.00.1104141459510.13286@chino.kir.corp.google.com>
References: <20110414200139.ABD98551@kernel> <20110414200141.09C3AA5F@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Dave Hansen wrote:

> 
> Michal Nazarewicz noticed that __alloc_pages_exact()'s
> __free_page() loop was really close to something he was
> using in one of his patches.   That made me realize that
> it was actually very similar to __free_pages_exact().
> 
> This uses __free_pages_exact() in place of the loop
> that we had in __alloc_pages_exact().  Since we had to
> change the temporary variables around anyway, I gave
> them some better names to hopefully address some other
> review comments.
> 

No signed-off-by?

Acked-by: David Rientjes <rientjes@google.com>
