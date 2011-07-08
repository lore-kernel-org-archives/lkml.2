Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab1GHEPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:15:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:36532 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab1GHEO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:14:57 -0400
Subject: Re: [PATCH 4/5] powerpc: Create next_tlbcam_idx percpu variable for FSL_BOOKE
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <13092911313115-git-send-email-beckyb@kernel.crashing.org>
Date: Thu, 7 Jul 2011 23:13:55 -0500
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        david@gibson.dropbear.id.au, wli@holomorphy.com,
        benh@kernel.crashing.org
Content-Transfer-Encoding: 7bit
Message-Id: <57D1124F-C59B-4292-9628-257C84390E6B@kernel.crashing.org>
References: <1309290888309-git-send-email-beckyb@kernel.crashing.org> <13092909493748-git-send-email-beckyb@kernel.crashing.org> <13092910103675-git-send-email-beckyb@kernel.crashing.org> <13092910702553-git-send-email-beckyb@kernel.crashing.org> <13092911313115-git-send-email-beckyb@kernel.crashing.org>
To: Becky Bruce <beckyb@kernel.crashing.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 28, 2011, at 2:54 PM, Becky Bruce wrote:

> From: Becky Bruce <beckyb@kernel.crashing.org>
> 
> This is used to round-robin TLBCAM entries.
> 
> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
> ---
> arch/powerpc/include/asm/mmu.h |    5 +++++
> arch/powerpc/kernel/smp.c      |    4 ++++
> arch/powerpc/mm/mem.c          |    9 +++++++++
> arch/powerpc/mm/tlb_nohash.c   |    6 ++++++
> 4 files changed, 24 insertions(+), 0 deletions(-)

applied to next

- k
