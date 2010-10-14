Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0JNFAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 01:00:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43078 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab0JNFAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 01:00:37 -0400
Date: Wed, 13 Oct 2010 23:00:33 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Subject: Re: linux-next: build warning after merge of the spi tree
Message-ID: <20101014050033.GL15286@angua.secretlab.ca>
References: <20101014125952.e4be4c9b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014125952.e4be4c9b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 12:59:52PM +1100, Stephen Rothwell wrote:
> Hi Grant,
> 
> After merging the rcu tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> drivers/spi/spi_topcliff_pch.c: In function 'pch_spi_process_messages':
> drivers/spi/spi_topcliff_pch.c:752: warning: 'data' is used uninitialized in this function
> 
> and, indeed it is ...

Oops, so it is.  I messed that up in the refactoring patch.
Fortunately this is a new driver so it is not a regression.  I'll push
out the fix this evening.

g.


