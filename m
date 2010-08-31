Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0HaKWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 06:22:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:45076 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab0HaKWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 06:22:42 -0400
Date: Tue, 31 Aug 2010 12:22:39 +0200
From: Michal Marek <mmarek@suse.cz>
To: Nicolas Palix <npalix@diku.dk>
Cc: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 00/18] Add new semantic patches and reorganize existing
 ones
Message-ID: <20100831102239.GA18142@sepie.suse.cz>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 05:38:54PM +0200, Nicolas Palix wrote:
> The following series adds new semantic patches (SPs) in scripts/coccinelle.
> Existing SPs are reorganized accordingly.
> 
> Nicolas Palix (18):
>   Coccinelle: Add null/eno.cocci
>   Coccinelle: Add null/kmerr.cocci
>   Coccinelle: Move deref_null.cocci to a more appropriate directory
>   Coccinelle: Add locks/call_kern.cocci
>   Coccinelle: Add locks/double_lock.cocci
>   Coccinelle: Add locks/mini_lock.cocci
>   Coccinelle: Add iterators/fen.cocci
>   Coccinelle: Add iterators/itnull.cocci
>   Coccinelle: Add iterators/list_entry_update.cocci
>   Coccinelle: Add free/kfree.cocci
>   Coccinelle: Add api/kstrdup.cocci
>   Coccinelle: Add api/memdup.cocci
>   Coccinelle: Add api/memdup_user
>   Coccinelle: Move err_cast.cocci to the api directory
>   Coccinelle: Move resource_size.cocci to the api directory
>   Coccinelle: Move alloc directory into api directory
>   Coccinelle: Add misc/doubleinit.cocci
>   Coccinelle: Add misc/ifcol.cocci

Applied, thanks.

Michal
