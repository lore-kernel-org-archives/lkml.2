Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab1EKWsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:48:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569Ab1EKWsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:48:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=bqljyBe/yOpy5EnsbDfyyiYwg8V9FggaLOpUwDXH59CQ/RS0ZXQg/EFd0VVXe3qPcP
         OYI+c9q8b/b4lrCoTLAA==
Date: Wed, 11 May 2011 15:47:49 -0700 (PDT)
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
In-Reply-To: <20110502211915.GB4623@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1105111547160.24003@chino.kir.corp.google.com>
References: <20110502211915.GB4623@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011, Daniel Kiper wrote:

> Memory hotplug code strictly depends on CONFIG_SPARSEMEM.
> It means that code depending on CONFIG_FLATMEM in online_page()
> is never compiled. Remove it because it is not needed anymore.
> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>

The code you're patching depends on CONFIG_MEMORY_HOTPLUG_SPARSE, so this 
is valid.  The changelog should be updated to reflect that, however.

Acked-by: David Rientjes <rientjes@google.com>
