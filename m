Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1ESFmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 01:42:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:33453 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab1ESFmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 01:42:04 -0400
Subject: Re: [PATCH] powerpc/mpc8610_hpcd: Do not use "/" in interrupt names
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <alpine.DEB.2.00.1105041627560.2601@ayla.of.borg>
Date: Thu, 19 May 2011 00:41:47 -0500
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <914167DB-90BD-4ABA-B305-84918FA14BF9@kernel.crashing.org>
References: <alpine.DEB.2.00.1105041627560.2601@ayla.of.borg>
To: Geert Uytterhoeven <geert@linux-m68k.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4, 2011, at 9:29 AM, Geert Uytterhoeven wrote:

> It may trigger a warning in fs/proc/generic.c:__xlate_proc_name() when
> trying to add an entry for the interrupt handler to sysfs.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> arch/powerpc/platforms/86xx/mpc8610_hpcd.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)

applied to next, will CC for stable (2.6.39.1)

- k
