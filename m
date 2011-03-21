Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1CUM4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:56:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37665 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab1CUM42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:56:28 -0400
Date: Mon, 21 Mar 2011 12:56:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nick Piggin <npiggin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 08/19] ARM: LPAE: Introduce the 3-level page table
	format definitions
Message-ID: <20110321125606.GC22222@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-9-git-send-email-catalin.marinas@arm.com> <AANLkTi=d0q0Upde3=b4tpu3icOr4XdifcFRvBHuXgsBN@mail.gmail.com> <20110124214225.GO24104@n2100.arm.linux.org.uk> <AANLkTikH9tBTGCiJ-+dvhh1tajMVq_6ua41MMZmq48sC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikH9tBTGCiJ-+dvhh1tajMVq_6ua41MMZmq48sC@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 12:36:55PM +0000, Catalin Marinas wrote:
> Any plans for the nopmd patches? I haven't seen them in -next or on the list.

I dropped them again because of those pesky warnings, so again I'm not
planning to push them this window as I don't wish to be deluged in
people reporting the warnings.

They really need fixing once we know how the LPAE stuff interacts with
the change.  At the moment I've no idea whether the existing section
support ends up at pgd or pmd level with LPAE.

Obviously that matters as with LPAE, pgd and pmd are different hardware
levels, but without LPAE they're the same hardware level.
