Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab1DLRLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:11:53 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48851 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab1DLRLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:11:52 -0400
Subject: Re: [PATCH 1/3] rename alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <87r597jt45.fsf@gmail.com>
References: <20110411220345.9B95067C@kernel>  <87r597jt45.fsf@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 12 Apr 2011 10:11:45 -0700
Message-ID: <1302628305.8321.2274.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 02:07 +0900, Namhyung Kim wrote:
> >                       if (get_order(size) < MAX_ORDER) {
> > -                             table = alloc_pages_exact(size, GFP_ATOMIC);
> > +                             table = get_free_pages_exact(size, GFP_ATOMIC);
> 
> This should be                  table = get_free_pages_exact(GFP_ATOMIC, size);

It's clear that I'm retarded and need to learn how to use sparse.  :)

Thanks!

-- Dave

