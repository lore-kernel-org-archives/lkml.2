Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1C1WmC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:42:02 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10298 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1C1WmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=VDjxMp/DTIXuzNrgVINhhwdVCjSZTNaXiJ3j+W12+UW44iHQiwTzBNNeGIw+5Jw6Ys
         5tnNcLcPlAmFu+htVfBw==
Date: Mon, 28 Mar 2011 15:41:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Kiper <dkiper@net-space.pl>
cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: Optimize pfn calculation in online_page()
In-Reply-To: <20110328092310.GB13826@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1103281541420.7148@chino.kir.corp.google.com>
References: <20110328092310.GB13826@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Daniel Kiper wrote:

> If CONFIG_FLATMEM is enabled pfn is calculated in online_page()
> more than once. It is possible to optimize that and use value
> established at beginning of that function.
> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>

Acked-by: David Rientjes <rientjes@google.com>
