Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0G1Xmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:42:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44709 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab0G1Xmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:42:51 -0400
Message-ID: <4C50C046.4040204@zytor.com>
Date: Wed, 28 Jul 2010 16:41:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Ralph Campbell <ralph.campbell@qlogic.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Infinipath <Infinipath@qlogic.com>
Subject: Re: [PATCH 31/31] memblock: Add memblock_find_in_range()
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>	 <1279822864-17154-32-git-send-email-yinghai@kernel.org>	 <1280295415.1970.245.camel@pasglop> <4C4FC95F.6040806@kernel.org>	 <4C4FD04B.5090503@zytor.com> <1280336548.30808.489.camel@mulgrave.site>	 <4C506E9B.4070501@zytor.com> <1280340633.30808.583.camel@mulgrave.site>	 <4C507728.3000207@zytor.com> <1280357909.9969.6.camel@chromite.mv.qlogic.com>
In-Reply-To: <1280357909.9969.6.camel@chromite.mv.qlogic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 03:58 PM, Ralph Campbell wrote:
> 
> I read the messages in this thread but I don't understand what the
> problem is. Something to do with logging, DMA and crash dumps but
> it also sounds like the original discussion may be confused about
> how the Infiniband HCA cards work.
> 
> Can someone summarize what is going on...
> 

Sorry, I was confused... this had to do with the qla driver, not Infinipath.

	-hpa
