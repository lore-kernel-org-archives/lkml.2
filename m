Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0L3Stk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 13:49:40 -0500
Received: from smtp-out.google.com ([74.125.121.67]:41706 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0L3Stj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 13:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=KmD6+zyIAVAq71a1xxP/1tGnR2BGU6TAy6yP0bN3aTb7t7CuYHkxpRIE1SvuMhRTXx
         J5DjmHo1z5ZGfxJ5ubfg==
Date: Thu, 30 Dec 2010 10:49:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Kiper <dkiper@net-space.pl>
cc: ian.campbell@citrix.com, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>, haicheng.li@linux.intel.com,
        fengguang.wu@intel.com, jeremy@goop.org, konrad.wilk@oracle.com,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH R2 1/7] mm: Add add_registered_memory() to memory hotplug
 API
In-Reply-To: <20101230123013.GA12765@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1012301048550.12995@chino.kir.corp.google.com>
References: <20101229170212.GF2743@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1012291643290.6040@chino.kir.corp.google.com> <20101230123013.GA12765@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, Daniel Kiper wrote:

> > Looks like this patch was based on a kernel before 2.6.37-rc4 since it
> > doesn't have 20d6c96b5f (mem-hotplug: introduce {un}lock_memory_hotplug())
> 
> As I wrote in "[PATCH R2 0/7] Xen memory balloon driver with memoryhotplug
> support" this patch applies to Linux kernel Ver. 2.6.36.
> 

I'd suggest posting patches against the latest -git.
