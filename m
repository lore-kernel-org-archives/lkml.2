Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab2FMVxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:53:54 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:2830 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226Ab2FMVxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:53:53 -0400
Message-ID: <1339624431.30984.185.camel@x61.thuisdomein>
Subject: Re: [PATCH] MIPS: remove three unused headers
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Wed, 13 Jun 2012 23:53:51 +0200
In-Reply-To: <20120613145614.GC5516@linux-mips.org>
References: <1339491792.30984.110.camel@x61.thuisdomein>
	 <20120613145614.GC5516@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 13 Jun 2012 21:53:52.0207 (UTC) FILETIME=[0562ADF0:01CD49AF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 15:56 +0100, Ralf Baechle wrote:
> On Tue, Jun 12, 2012 at 11:03:12AM +0200, Paul Bolle wrote:
> 
> > No file includes these three headers. It seems they have never been
> > included since at least v2.6.12-rc2. They can safely be removed.
> 
> >  arch/mips/include/asm/sibyte/sb1250_l2c.h |  131 -------
> >  arch/mips/include/asm/sibyte/sb1250_ldt.h |  422 ----------------------
> >  arch/mips/include/asm/sibyte/sb1250_mc.h  |  550 -----------------------------
> 
> These headers describe the on-chip hardware of the SB1250 SOC.  Some of
> the drivers to use them are currently stuck midflight on their path to
> submission.

OK, I see. Thanks.

>   The remaining ones I'd like to keep around as documentation
> or for later use.

I'd say that arch/mips/include/ is were one puts code and
Documentation/mips/ is were one puts documentation. Can't the unused
header files you want to keep (preferably with, say, a .txt extension)
be added to Documentation/mips/?
 
>   Ditto for your other BCM1480 related patch....

Thanks,


Paul Bolle

