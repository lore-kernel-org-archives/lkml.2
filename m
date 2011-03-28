Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1C1Woj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:44:39 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17533 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab1C1Woh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:44:37 -0400
Date: Tue, 29 Mar 2011 00:44:39 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Daniel Kiper <dkiper@net-space.pl>
cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: Optimize pfn calculation in online_page()
In-Reply-To: <20110328092310.GB13826@router-fw-old.local.net-space.pl>
Message-ID: <alpine.LNX.2.00.1103290043480.23292@swampdragon.chaosbits.net>
References: <20110328092310.GB13826@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Daniel Kiper wrote:

> If CONFIG_FLATMEM is enabled pfn is calculated in online_page()
> more than once. It is possible to optimize that and use value
> established at beginning of that function.
> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>

This looks sane to me.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

