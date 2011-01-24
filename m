Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1AXVmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:42:39 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33001 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1AXVmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:42:38 -0500
Date: Mon, 24 Jan 2011 21:42:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nick Piggin <npiggin@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 08/19] ARM: LPAE: Introduce the 3-level page table
	format definitions
Message-ID: <20110124214225.GO24104@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-9-git-send-email-catalin.marinas@arm.com> <AANLkTi=d0q0Upde3=b4tpu3icOr4XdifcFRvBHuXgsBN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=d0q0Upde3=b4tpu3icOr4XdifcFRvBHuXgsBN@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 08:26:42AM +1100, Nick Piggin wrote:
> Too bad about the PAE thing; my condolences.
> 
> 
> On Tue, Jan 25, 2011 at 4:55 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > This patch introduces the pgtable-3level*.h files with definitions
> > specific to the LPAE page table format (3 levels of page tables).
> 
> Seeing as you're shaking up these definitions, what do you think about
> switching from 4level-fixup.h to pgtable-nopud.h / pgtable-nopmd.h headers?
> One day eventually it would be nice to get rid of the fixup mode.

I have patches to do this which I de-queued for the last merge window.
It's not entirely trivial and without problem.  You can find the patches
in linux-next now.

I was waiting for the new set of patches from Catalin before going back
and working out the solutions to some of those problems.
