Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab1K3MGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 07:06:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:30750 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab1K3MGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 07:06:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,596,1315206000"; 
   d="scan'208";a="80613935"
Date: Wed, 30 Nov 2011 20:06:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] readahead: snap readahead request to EOF
Message-ID: <20111130120603.GA19834@localhost>
References: <20111129130900.628549879@intel.com>
 <20111129131456.145362960@intel.com>
 <20111129142958.GJ5635@quack.suse.cz>
 <20111130010604.GD11147@localhost>
 <20111130113719.GC4541@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130113719.GC4541@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/* snap to EOF */
> > +	size += min(size, ra->ra_pages / 4);
>   I'd probably choose:
> 	size += min(size / 2, ra->ra_pages / 4);
>   to increase current window only to 3/2 and not twice but I don't have a

OK it looks good on large ra_pages. I'll use this form.

> strong opinion. Otherwise I think the code is fine now so you can add:
>   Acked-by: Jan Kara <jack@suse.cz>

Thanks! 

Fengguang
