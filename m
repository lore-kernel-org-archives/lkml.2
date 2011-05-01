Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980Ab1EAQhr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:37:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41125 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab1EAQhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:37:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bpxklPcOLrWIUkJcSN/zrqlov2GZi6ldW+V1dcvxpRb0etQJBCt467EB/8Llzhs5em
         XJKdn9WgXrl7Xqpyn2tOIudpXlNgjgMcYZBjfCcDHn1nqKZgLTFVk40DVnWVHag5ogNV
         99JOc8y6UFTJmPUPi+c9ZbO6+KM+Xf0C5sEBs=
Date: Mon, 2 May 2011 01:37:37 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Dave Chinner <david@fromorbit.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC][PATCH] mm: cut down __GFP_NORETRY page allocation
 failures
Message-ID: <20110501163737.GB3204@barrios-desktop>
References: <20110426062535.GB19717@localhost>
 <BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com>
 <20110426063421.GC19717@localhost>
 <BANLkTi=xDozFNBXNdGDLK6EwWrfHyBifQw@mail.gmail.com>
 <20110426092029.GA27053@localhost>
 <20110426124743.e58d9746.akpm@linux-foundation.org>
 <20110428133644.GA12400@localhost>
 <20110429022824.GA8061@localhost>
 <20110430141741.GA4511@localhost>
 <20110501163542.GA3204@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501163542.GA3204@barrios-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 01:35:42AM +0900, Minchan Kim wrote:
 
> Do you see my old patch? The patch want't incomplet but it's not bad for showing an idea.
                                     ^^^^^^^^^^^^^^^^
                              typo : wasn't complete
-- 
Kind regards,
Minchan Kim
