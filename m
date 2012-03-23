Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab2CWMYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:24:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63438 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2CWMYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:24:49 -0400
Date: Fri, 23 Mar 2012 13:24:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: mingo@elte.hu, suresh.b.siddha@intel.com, jwboyer@redhat.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, yinghai@kernel.org
Subject: Re: [PATCH 2/3] x86/apic_ops: Replace apic_ops with x86_apic_ops.
Message-ID: <20120323122444.GD13920@gmail.com>
References: <1332294154.16101.97.camel@sbsiddha-desk.sc.intel.com>
 <1332385090-18056-1-git-send-email-konrad.wilk@oracle.com>
 <1332385090-18056-3-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332385090-18056-3-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> . which makes the code fit within the rest of the x86_ops functions.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> [v1: Changed x86_apic -> x86_ioapic per Yinghai Lu <yinghai@kernel.org> suggestion]
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/include/asm/io_apic.h  |   40 +++++++++++++++++++++--------
>  arch/x86/include/asm/x86_init.h |    8 ++++++
>  arch/x86/kernel/apic/io_apic.c  |   54 ++++----------------------------------
>  arch/x86/kernel/setup.c         |    2 +-
>  arch/x86/kernel/x86_init.c      |    8 ++++++
>  5 files changed, 52 insertions(+), 60 deletions(-)

Ok, I guess we can do this.

Thanks,

	Ingo
