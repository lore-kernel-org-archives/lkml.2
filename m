Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab0EZATG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 20:19:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758455Ab0EZATE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 20:19:04 -0400
Date: Wed, 26 May 2010 10:18:55 +1000
From: Nick Piggin <npiggin@suse.de>
To: Albert Herranz <albert_herranz@yahoo.es>
Cc: jayakumar.lkml@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev@vger.kernel.org
Subject: Re: [RFT PATCH 2/2] fb_defio: redo fix for non-dirty ptes
Message-ID: <20100526001854.GL20853@laptop>
References: <1274825820-10246-1-git-send-email-albert_herranz@yahoo.es>
 <1274825820-10246-2-git-send-email-albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274825820-10246-2-git-send-email-albert_herranz@yahoo.es>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 12:17:00AM +0200, Albert Herranz wrote:
> As pointed by Nick Piggin, ->page_mkwrite provides a way to keep a page
> locked until the associated PTE is marked dirty.
> 
> Re-implement the fix by using this mechanism.
> 
> LKML-Reference: <20100525160149.GE20853@laptop>
> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>

Thanks for taking a look at this,

Acked-by: Nick Piggin <npiggin@suse.de>

