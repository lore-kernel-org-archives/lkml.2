Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab2CWIiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:38:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35888 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2CWIhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:37:55 -0400
Date: Fri, 23 Mar 2012 09:37:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, tlb: switch cr3 in leave_mm() only when needed
Message-ID: <20120323083751.GC2886@gmail.com>
References: <1332459220.16101.144.camel@sbsiddha-desk.sc.intel.com>
 <CA+55aFyf9RqAROx7t=CYUSGCDBXvv9z2c+LP1vRJjLU45_pD+Q@mail.gmail.com>
 <1332460885.16101.147.camel@sbsiddha-desk.sc.intel.com>
 <4F6BC1C4.6050502@zytor.com>
 <CA+55aFygUGmL0iCKYn5DBitrPSm0GHZ8e5j0j2OzcBcAkUMiFw@mail.gmail.com>
 <1332463899.16101.158.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332463899.16101.158.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> I was reviewing this code in some other context and thought 
> this optimization makes sense. Unless someone beats me, I can 
> collect some data on Monday.

Would be really nice to get this data.

Thanks,

	Ingo
