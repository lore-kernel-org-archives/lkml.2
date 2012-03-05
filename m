Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2CECxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 21:53:51 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:8102 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754920Ab2CECxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 21:53:50 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dKzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Subject: Re: [PATCH] powerpc/srio: Fix the compile errors when building
	with 64bit
From: Liu Gang <Gang.Liu@freescale.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <r61911@freescale.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>
In-Reply-To: <4F50D98F.1040705@windriver.com>
References: <1330672127-22172-1-git-send-email-Gang.Liu@freescale.com>
	 <4F50D98F.1040705@windriver.com>
Content-Type: text/plain
Date: Mon, 5 Mar 2012 10:52:24 +0800
Message-ID: <1330915944.23420.115.camel@10.ap.freescale.net>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul,

On Fri, 2012-03-02 at 09:30 -0500, Paul Gortmaker wrote:
> > Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> > Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> Hi Liu,
> 
> You can't just go adding a "Signed-off-by:" line for me to a patch that
> I've never seen before.  Perhaps you meant to add "Reported-by:" ?
> 
> Paul.

I'm sorry for this. I added "Signed-off-by" for you because I wanted to
thank you found this issue. I'll add "Reported-by:" if needed in the
future.

Best Regards,

Liu Gang


