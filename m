Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1CFQhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 11:37:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41203 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1CFQhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 11:37:10 -0500
Date: Sun, 6 Mar 2011 16:36:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ARM] tlb: fix build error with CONFIG_SWAP=n
Message-ID: <20110306163656.GH27468@n2100.arm.linux.org.uk>
References: <1299426386-28746-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1299426386-28746-1-git-send-email-dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 06, 2011 at 06:46:26PM +0300, Dmitry Eremin-Solenikov wrote:
> Fix this build error with CONFIG_SWAP=n:
> 
> In file included from arch/arm/mm/init.c:28:
> arch/arm/include/asm/tlb.h: In function ‘tlb_flush_mmu’:
> arch/arm/include/asm/tlb.h:104: error: implicit declaration of function ‘release_pages’
> arch/arm/include/asm/tlb.h: In function ‘tlb_remove_page’:
> arch/arm/include/asm/tlb.h:168: error: implicit declaration of function ‘page_cache_release’

Already caught:

http://ftp.arm.linux.org.uk/git/?p=linux-2.6-arm.git;a=shortlog;h=refs/heads/fixes

11 days    Uwe Kleine...   ARM: 6757/1: fix tlb.h induced linux/swap.h
ago                        build failure

I've had about four of these patches over the last two weeks or so,
it would be a good idea to check the git tree before sending another
version of this.
