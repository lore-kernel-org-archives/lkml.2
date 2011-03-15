Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab1COTTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:19:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:39688 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758353Ab1COTTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:19:46 -0400
Subject: Re: [PATCH] powerpc: sysdev: fix signedness bug
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1287327102-9068-1-git-send-email-segooon@gmail.com>
Date: Tue, 15 Mar 2011 14:19:23 -0500
Cc: kernel-janitors@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Vivek Mahajan <vivek.mahajan@freescale.com>,
        Harninder Rai <harninder.rai@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 7bit
Message-Id: <EA2A84CF-6A11-4CEC-B4FD-96F1262ED9AF@kernel.crashing.org>
References: <1287327102-9068-1-git-send-email-segooon@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 17, 2010, at 9:51 AM, Vasiliy Kulikov wrote:

> sram_params.sram_size and sram_params.sram_offset were unsigned.
> If get_cache_sram_size() or get_cache_sram_offset() returns error code
> then it is not seen to the caller.  Made sram_size and sram_offset signed.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
> arch/powerpc/sysdev/fsl_85xx_l2ctlr.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)

applied

- k
