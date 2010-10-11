Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0JKNbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:31:47 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:58612 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab0JKNbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:31:46 -0400
X-Greylist: delayed 3537 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Oct 2010 09:31:45 EDT
Date: Mon, 11 Oct 2010 13:30:23 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: ddaney@caviumnetworks.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MIPS: Reinstate plat_map_dma_mem_page()
Message-ID: <20101011123023.GA26997@linux-mips.org>
References: <9ab1e21b7c9b1b40a3de371d3a35ebd3@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ab1e21b7c9b1b40a3de371d3a35ebd3@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 06:50:13PM -0700, Kevin Cernekee wrote:

> [Patch is against linux-queue.git]
> 
> plat_map_dma_mem_page() is required in order to translate a "struct page"
> directly to a physical address.  plat_map_dma_mem() is not effective on
> HIGHMEM pages.

Seems to make sense.  I've folded your patch into patch 6 of David Daney's
series and fixed up the resulting reject in patch 8.

Thanks!

  Ralf
