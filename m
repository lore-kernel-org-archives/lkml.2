Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1DNWHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:07:14 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54056 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab1DNWHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:07:11 -0400
Subject: Re: [PATCH 3/3] reuse __free_pages_exact() in __alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>
In-Reply-To: <alpine.DEB.2.00.1104141459510.13286@chino.kir.corp.google.com>
References: <20110414200139.ABD98551@kernel>
	 <20110414200141.09C3AA5F@kernel>
	 <alpine.DEB.2.00.1104141459510.13286@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 14 Apr 2011 15:07:05 -0700
Message-ID: <1302818825.16562.1094.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 15:00 -0700, David Rientjes wrote:
> On Thu, 14 Apr 2011, Dave Hansen wrote:
> > Michal Nazarewicz noticed that __alloc_pages_exact()'s
> > __free_page() loop was really close to something he was
> > using in one of his patches.   That made me realize that
> > it was actually very similar to __free_pages_exact().
> > 
> > This uses __free_pages_exact() in place of the loop
> > that we had in __alloc_pages_exact().  Since we had to
> > change the temporary variables around anyway, I gave
> > them some better names to hopefully address some other
> > review comments.
> 
> No signed-off-by?

Bah, sorry.  I'll resend the whole sucker, with sob if anybody wants.
Otherwise:

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>


