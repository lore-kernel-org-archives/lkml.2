Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab0H1A62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 20:58:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab0H1A61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 20:58:27 -0400
Subject: Re: [PATCH] powerpc/kvm/e500_tlb: Fix a minor copy-paste tracing bug
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1282936005-17078-1-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Sat, 28 Aug 2010 02:58:23 +0200
Cc: linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Liu Yu <yu.liu@freescale.com>,
        Kyle Moffett <kyle@moffetthome.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <B3286B71-599C-405E-847F-06B843A46449@suse.de>
References: <1282936005-17078-1-git-send-email-Kyle.D.Moffett@boeing.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 27.08.2010, at 21:06, Kyle Moffett wrote:

> The kvmppc_e500_stlbe_invalidate() function was trying to pass too many
> parameters to trace_kvm_stlb_inval().  This appears to be a bad
> copy-paste from a call to trace_kvm_stlb_write().

Which kernel is this against? That trace point is already commented out in my tree.


Alex

