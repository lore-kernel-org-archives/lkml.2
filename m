Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1DNWJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:09:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10678 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab1DNWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=JPVWGgW/YsDdSGb4F0Q/ybquSBvzXORWiwA6YX6Q0vHh9cK1rgSbCrEXK7MI5AlrTP
         mBmNYo0URNzHI87fKOcQ==
Date: Thu, 14 Apr 2011 15:09:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 3/3] reuse __free_pages_exact() in
 __alloc_pages_exact()
In-Reply-To: <1302818825.16562.1094.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1104141508370.13286@chino.kir.corp.google.com>
References: <20110414200139.ABD98551@kernel> <20110414200141.09C3AA5F@kernel> <alpine.DEB.2.00.1104141459510.13286@chino.kir.corp.google.com> <1302818825.16562.1094.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Dave Hansen wrote:

> Bah, sorry.  I'll resend the whole sucker, with sob if anybody wants.
> Otherwise:
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> 

I think it's good to go into -mm as-is, unless anybody else has any 
objections to it.  I'd also suggest adding a

	Suggested-by: Michal Nazarewicz <mina86@mina86.com>

for this patch even though it's explained in the changelog already.

Thanks, Dave!
