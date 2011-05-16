Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab1EPUc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:32:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16489 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab1EPUc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:32:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ydkUz7S/2hasR8um1K2r3xr5AlRLlvblLZ00I+Tny4Y919b8XiE8gxyBahzVti8iJK
         9lVtknHIWNIQJFcmYwqg==
Date: Mon, 16 May 2011 13:32:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Kiper <dkiper@net-space.pl>
cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: Remove dependency on CONFIG_FLATMEM from
 online_page()
In-Reply-To: <20110516075849.GB6393@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1105161330570.4353@chino.kir.corp.google.com>
References: <20110502211915.GB4623@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1105111547160.24003@chino.kir.corp.google.com> <20110512102515.GA27851@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1105121223500.2407@chino.kir.corp.google.com>
 <20110516075849.GB6393@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011, Daniel Kiper wrote:

> > No, I would just reply to the email notification you received when the
> > patch went into -mm saying that the changelog should be adjusted to read
> > something like
> >
> > 	online_pages() is only compiled for CONFIG_MEMORY_HOTPLUG_SPARSE,
> > 	so there is no need to support CONFIG_FLATMEM code within it.
> >
> > 	This patch removes code that is never used.
> 
> Please look into attachments.
> 
> If you have any questions please drop me a line.
> 

Not sure why you've attached the emails from the mm-commits mailing list.  
I'll respond to the commits with with my suggestions for how the changelog 
should be fixed.

Thanks.
