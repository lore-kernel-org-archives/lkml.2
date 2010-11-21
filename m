Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0KUPHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 10:07:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35266 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab0KUPHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 10:07:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YFnniTYW583VVssKOVkPeAsTyJqzASBSbk3Rux7pyjIn8sDdLICm5eYOzk8xoIKuhd
         qp2/BX6XOrAuDi/JqgyXyiIzHnqoi4wvlMQPi9yC5JNZLU/04567lfzcAPBNUEDA/6BF
         Atyh2ZJ9UxqNrAslcAmx0zefxvFluhUEuwrUE=
Date: Mon, 22 Nov 2010 00:07:23 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bob Liu <lliubbo@gmail.com>, fujita.tomonori@lab.ntt.co.jp,
        m.nazarewicz@samsung.com, pawel@osciak.com, andi.kleen@intel.com,
        felipe.contreras@gmail.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/4] alloc_contig_pages() move some functions to
 page_isolation.c
Message-ID: <20101121150723.GA20947@barrios-desktop>
References: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
 <20101119171239.7f544c7c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119171239.7f544c7c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 05:12:39PM +0900, KAMEZAWA Hiroyuki wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Memory hotplug is a logic for making pages unused in the specified range
> of pfn. So, some of core logics can be used for other purpose as
> allocating a very large contigous memory block.
> 
> This patch moves some functions from mm/memory_hotplug.c to
> mm/page_isolation.c. This helps adding a function for large-alloc in
> page_isolation.c with memory-unplug technique.
> 
> Changelog: 2010/10/26
>  - adjusted to mmotm-1024 + Bob's 3 clean ups.
> Changelog: 2010/10/21
>  - adjusted to mmotm-1020
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
