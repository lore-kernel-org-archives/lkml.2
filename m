Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab0IXHFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 03:05:21 -0400
Received: from fly.osdn.org.ua ([212.40.45.6]:40567 "EHLO fly.osdn.org.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab0IXHFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 03:05:20 -0400
Date: Fri, 24 Sep 2010 10:05:16 +0300
From: Michael Shigorin <mike@osdn.org.ua>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>,
        Alexander Chumachenko <ledest@gmail.com>,
        Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: fs hang in 2.6.27.y | Fwd: [Bug 15658] New: [PATCH] x86 constant_test_bit() prone to misoptimization with gcc-4.4
Message-ID: <20100924070516.GJ15790@osdn.org.ua>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>,
	Alexander Chumachenko <ledest@gmail.com>,
	Glauber de Oliveira Costa <gcosta@redhat.com>
References: <20100827213629.GA11342@osdn.org.ua> <20100923165022.6982ffc1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923165022.6982ffc1.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 04:50:22PM -0700, Andrew Morton wrote:
> (huge quote)

Andrew, huge THANKS for getting to this!

> Working around a gcc-4.4 bug is a good thing, and the patch
> cleans the code up anyway - is there a reason for casting away
> the `volatile const'?

We'll discuss this; I'm actually no kernel developer (a silly
local iso9660 patch in 1999, nothing more) but rather a proxy.

> We don't have a Signed-off-by: for this patch - it would be
> good to have one, please.  We should at least have yours, as
> you sent the patch.

OK, Greg already told us to do so for stable@ but things were
busy there as well.  We'll fix up.

> Also, we prefer to have real names in kernel commits.
> Does "Led" refer to Alexander Chumachenko?

Yes.

2 led: a signed-off patch, please? :)

-- 
 ---- WBR, Michael Shigorin <mike@altlinux.ru>
  ------ Linux.Kiev http://www.linux.kiev.ua/
