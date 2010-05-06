Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab0EFK7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 06:59:53 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55211 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab0EFK7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 06:59:50 -0400
Date: Thu, 6 May 2010 04:59:48 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: wzt.wzt@gmail.com, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, deller@gmx.de, jejb@parisc-linux.org
Subject: Re: [PATCH] Parisc: Check kmalloc return value before use the
	buffer in ccio-dma.c
Message-ID: <20100506105948.GV6747@parisc-linux.org>
References: <20100506024208.GB15956@localhost.localdomain> <20100506040331.GC4902@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506040331.GC4902@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 12:03:31AM -0400, Kyle McMartin wrote:
> We can change it to GFP_ATOMIC|__GFP_NOFAIL so it will retry infinitely,
> or we can panic in the error path with a nice error message so the users
> knows why his machine isn't going to work.

If we can't initialise the IOMMU, can we even get a panic message out to
the user?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
