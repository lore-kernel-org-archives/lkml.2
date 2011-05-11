Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab1EKXK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 19:10:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15506 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab1EKXK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 19:10:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qclpiIMaLpzut7LZQDqq1HfOr1ZGf3sDuTlHfe8lKS2a8fcyBfTLinAJkbO+rk6vvx
         0v2BQYhm/989lmy6efBQ==
Date: Wed, 11 May 2011 16:10:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Kiper <dkiper@net-space.pl>
cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] mm: Enable set_page_section() only if CONFIG_SPARSEMEM
 and !CONFIG_SPARSEMEM_VMEMMAP
In-Reply-To: <20110502212012.GC4623@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1105111605050.24003@chino.kir.corp.google.com>
References: <20110502212012.GC4623@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011, Daniel Kiper wrote:

> set_page_section() is valid only in CONFIG_SPARSEMEM and
> !CONFIG_SPARSEMEM_VMEMMAP context.

s/valid/needed/.  set_page_section() _is_ valid in all contexts since 
SECTIONS_MASK and SECTIONS_PGSHIFT is defined in all contexts.  

> Move it to proper place
> and amend accordingly functions which are using it.
> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>

After the changelog is fixed:

	Acked-by: David Rientjes <rientjes@google.com>
