Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab1ADMGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 07:06:51 -0500
Received: from canuck.infradead.org ([134.117.69.58]:34778 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1ADMGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 07:06:50 -0500
Subject: Re: [PATCH 6/7] perf: Use MSR names in the extra reg lists
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1293464296.2695.107.camel@localhost>
References: <1293464296.2695.107.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 13:07:05 +0100
Message-ID: <1294142825.2016.134.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-27 at 23:38 +0800, Lin Ming wrote:
> @@ -88,7 +88,8 @@ static struct event_constraint intel_nehalem_event_constraints[] =
>  
>  static struct extra_reg intel_nehalem_extra_regs[] =
>  {
> -       INTEL_EVENT_EXTRA_REG(0xb7, 0x1a6, 0xffff, 32), /* OFFCORE_RESPONSE */
> +       /* OFFCORE_RESPONSE */
> +       INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, 32),
>         EVENT_EXTRA_END
>  }; 

Since we're going for another posting anyway, I think you can drop that
comment here, it should be evident from the MSR name included in the
constraint.
