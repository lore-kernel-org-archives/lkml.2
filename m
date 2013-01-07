Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab3AGQmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:42:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:59437 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab3AGQmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:42:21 -0500
Subject: Re: [PATCH] powerpc/mm: eliminate unneeded for_each_memblock
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1357322760-12197-1-git-send-email-cody@linux.vnet.ibm.com>
Date: Mon, 7 Jan 2013 10:42:02 -0600
Cc: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Content-Transfer-Encoding: 7bit
Message-Id: <82A31E2D-FA24-44CF-9812-9E8062AFA6F4@kernel.crashing.org>
References: <1357322760-12197-1-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 4, 2013, at 12:06 PM, Cody P Schafer wrote:

> The only persistent change made by this loop is calling
> memblock_set_node() once for each memblock, which is not useful (and has
> no effect) as memblock_set_node() is not called with any
> memblock-specific parameters.
> 
> Subsistute a single memblock_set_node().
> ---
> arch/powerpc/mm/mem.c | 9 ++-------
> 1 file changed, 2 insertions(+), 7 deletions(-)

Missing a signed-off-by

- k
