Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab0HaBHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 21:07:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539Ab0HaBHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 21:07:49 -0400
Subject: Re: [PATCH] powerpc/kvm/e500_tlb: Fix a minor copy-paste tracing bug
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1283182719-4621-1-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Tue, 31 Aug 2010 03:07:43 +0200
Cc: linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Liu Yu <yu.liu@freescale.com>,
        Kyle Moffett <kyle@moffetthome.net>
Content-Transfer-Encoding: 7bit
Message-Id: <4B040308-883F-4A90-BEA4-034DC6B2C6A6@suse.de>
References: <1282936005-17078-1-git-send-email-Kyle.D.Moffett@boeing.com> <1283182719-4621-1-git-send-email-Kyle.D.Moffett@boeing.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 30.08.2010, at 17:38, Kyle Moffett wrote:

> The kvmppc_e500_stlbe_invalidate() function was trying to pass too many
> parameters to trace_kvm_stlb_inval().  This appears to be a bad
> copy-paste from a call to trace_kvm_stlb_write().
> 
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>

Thanks, applied.

Alex

