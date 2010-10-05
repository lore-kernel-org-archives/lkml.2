Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab0JEFqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:46:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:33047 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab0JEFqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:46:21 -0400
Message-ID: <4CAABC0E.3030700@kernel.org>
Date: Tue, 05 Oct 2010 07:47:58 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the lost-spurious-irq tree with the
 tip tree
References: <20101005141334.6a0f15fd.sfr@canb.auug.org.au>
In-Reply-To: <20101005141334.6a0f15fd.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Oct 2010 05:45:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

On 10/05/2010 05:13 AM, Stephen Rothwell wrote:
> Hi Tejun,
> 
> Today's linux-next merge of the lost-spurious-irq tree got a conflict in
> kernel/irq/spurious.c between commits
> 6b8ff3120c758340505dddf08ad685ebb841d5d5 ("genirq: Convert core code to
> irq_data") and bd151412263a67b5321e9dd1d5b4bf6d96fdebf3 ("genirq: Provide
> config option to disable deprecated code") from the tip tree and commits
> 32b5d378f49485f3ae172eb0ac2bfc4ebbbdb060 ("irq: cleanup irqfixup") and
> 80f97e2b33c3e66c11b10abd2890506a3abeb320 ("irq: make spurious poll timer
> per desc") from the lost-spurious-irq tree.
> 
> I think I fixed it all up (see below).  I can carry this fix (or a better
> one) as necessary.

Can you please drop lost-spurious-irq for now?  It needs to be
reimplemented.  I'll send a merge request again when it's ready.

Thank you.

-- 
tejun
