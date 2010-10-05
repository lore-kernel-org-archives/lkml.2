Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0JEG5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 02:57:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:34909 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276Ab0JEG5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 02:57:39 -0400
Message-ID: <4CAACCC1.6000000@kernel.org>
Date: Tue, 05 Oct 2010 08:59:13 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the lost-spurious-irq tree with the
 tip tree
References: <20101005141334.6a0f15fd.sfr@canb.auug.org.au> <4CAABC0E.3030700@kernel.org> <20101005063227.GB12267@elte.hu> <4CAACBDA.6090308@kernel.org>
In-Reply-To: <4CAACBDA.6090308@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Oct 2010 06:57:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 08:55 AM, Tejun Heo wrote:
> I think Stephen had done enough.  At the time, I wasn't sure which
> tree it was going to go through and it took some time before Thomas
> responded, so I was intending to push it through separately.  I should
> have retracted the tree right after it was determined to be
> reimplemented but forgot.  That's my mistake not Stephen's.  Sorry
> about that.

Oooh, apparently I knew it was gonna go through genirq but expected it
to go through as-is and wanted to accelerate testing.  FWIW, I'm
sure everyone involved was notified of the move at the time.  At any
rate, won't happen again.

Thanks.

-- 
tejun
