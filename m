Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab2C1JYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:24:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49623 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab2C1JYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:24:07 -0400
Date: Wed, 28 Mar 2012 11:23:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: mingo@elte.hu, suresh.b.siddha@intel.com, jwboyer@redhat.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, yinghai@kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/3] x86: add io_apic_ops to allow interception
Message-ID: <20120328092358.GD22885@gmail.com>
References: <1332294154.16101.97.camel@sbsiddha-desk.sc.intel.com>
 <1332385090-18056-1-git-send-email-konrad.wilk@oracle.com>
 <1332385090-18056-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332385090-18056-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Xen dom0 needs to paravirtualize IO operations to the IO APIC, so add
> a io_apic_ops for it to intercept.  Do this as ops structure because
> there's at least some chance that another paravirtualized environment
> may want to intercept these.
> 
> [ Impact: indirect IO APIC access via io_apic_ops ]
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/include/asm/io_apic.h |    9 +++++++
>  arch/x86/kernel/apic/io_apic.c |   50 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 56 insertions(+), 3 deletions(-)

Ok, I have applied a cleaned up version of this patch.

The followup patch does not apply anymore - please merge it and 
resubmit.

Thanks,

	Ingo
