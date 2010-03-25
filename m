Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab0CYI2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:28:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:46638 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0CYI2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:28:30 -0400
Subject: Re: [PATCH 1/2] mm/vmalloc: Export purge_vmap_area_lazy()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nathan Fontenot <nfont@austin.ibm.com>
In-Reply-To: <20100325052814.GA7493@laptop.nomadix.com>
References: <1269417391.8599.188.camel@pasglop>
	 <20100325052814.GA7493@laptop.nomadix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 19:25:59 +1100
Message-ID: <1269505559.8599.239.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You want vm_unmap_aliases(), which also flushes entries in the
> per-cpu vmap allocator (and is already exported for other code
> that has similar problems).

Ok, I missed that one. I'll update my patch. Thanks.

Cheers,
Ben.


