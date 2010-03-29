Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0C2HrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 03:47:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42241 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab0C2HrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 03:47:19 -0400
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH] x86: mce: Xeon75xx specific interface to get corrected memory error information v2
From: Andi Kleen <andi@firstfloor.org>
References: <20100324054044.GA4307@basil.fritz.box>
Date: Mon, 29 Mar 2010 09:47:18 +0200
In-Reply-To: <20100324054044.GA4307@basil.fritz.box> (Andi Kleen's message of "Wed, 24 Mar 2010 06:40:44 +0100")
Message-ID: <87vdcf7ent.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> x86: mce: Xeon75xx specific interface to get corrected memory error information v2

Ping?  Please review this patch. Thanks.
-Andi

>
> [This version addresses the previous comments. It does not change
> any interface to the outside and does not attempt to encode DIMMs
> or anything like that, but only passes out the physical address of u
> a corrected error in the standard ADDR register field. 
> So for the outside it looks exactly the same as if the CPU supported this 
> natively, but no otherwise special interfaces.
>
> I hope this addresses previous concerns. I guess the DIMM error reporting
> can be revisited once there's a new reporting interface. There are still
> some traces of DIMM parsing in there, but it's only used for debug
> purposes now.]
>
> ---
>
> Xeon 75xx doesn't log physical addresses on corrected machine check
> events in the standard architectural MSRs. Instead the address has to
> be retrieved in a model specific way. This makes it impossible
> to do predictive failure analysis.

-- 
ak@linux.intel.com -- Speaking for myself only.
