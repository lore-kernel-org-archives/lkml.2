Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1IWPzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:55:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33456 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab1IWPzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:55:11 -0400
Subject: Re: [RFC][PATCH] show page size in /proc/$pid/numa_maps
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1109221339520.31548@chino.kir.corp.google.com>
References: <20110921221329.5B7EE5C5@kernel>
	 <alpine.DEB.2.00.1109221339520.31548@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 08:54:28 -0700
Message-ID: <1316793268.16137.481.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 13:43 -0700, David Rientjes wrote:
> Why not just add a pagesize={4K,2M,1G,...} field for every output? 

I think it's a bit misleading.  With THP at least we have 2M pages in
the MMU, but we're reporting in 4k units.

I certainly considered doing just what you're suggesting, though.  It's
definitely not a bad idea.  Certainly much more clear.

-- Dave

