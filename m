Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab0C2NII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:08:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50060 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0C2NIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:08:05 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/2] perf: Use LBR for machine/oops debugging
From: Andi Kleen <andi@firstfloor.org>
References: <20100329122021.765109681@chello.nl>
Date: Mon, 29 Mar 2010 15:08:03 +0200
In-Reply-To: <20100329122021.765109681@chello.nl> (Peter Zijlstra's message of "Mon, 29 Mar 2010 14:20:21 +0200")
Message-ID: <87bpe7qnrg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> The LBRs are relatively cheap to keep enabled and provide some history
> to OOPSen, also some CPUs are reported to keep them over soft-reset,
> which allows us to use them to debug things like tripple faults.
>
> Therefore introduce a boot option: lbr_debug=on, which always enable
> the LBRs and will print the LBRs on CPU init and die().


die is too late. they will only contain the oops code then.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
