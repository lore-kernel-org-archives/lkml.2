Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab2EFKL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 06:11:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36915 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab2EFKLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 06:11:55 -0400
Date: Sun, 6 May 2012 11:11:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: SMP: prevent use of the console when using
	idmap_pgd
Message-ID: <20120506101141.GI26481@n2100.arm.linux.org.uk>
References: <1336180444-26563-1-git-send-email-ccross@android.com> <20120505164933.GQ897@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120505164933.GQ897@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 05:49:33PM +0100, Russell King - ARM Linux wrote:
> I think this is fine.  Please put it in the patch system, thanks.

It looks like this bug affects v3.2 kernels as well - should it be marked
for the attention of the stable kernel team?
