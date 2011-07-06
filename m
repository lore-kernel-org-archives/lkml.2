Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab1GFJ5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:57:09 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:28263 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab1GFJ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:57:07 -0400
X-IronPort-AV: E=Sophos;i="4.65,485,1304294400"; 
   d="scan'208";a="6645652"
Subject: Re: [PATCH 1/3] x86: drop unnecessary kernel_eflags variable from
 64 bit.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ingo Molnar" <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <20110706094602.GJ4060@sun>
References: <20110705111525.GR17941@sun>
	 <1309870814-14181-1-git-send-email-ian.campbell@citrix.com>
	 <20110705132825.GA3900@sun>
	 <1309944329.634.161.camel@zakaz.uk.xensource.com>
	 <20110706094602.GJ4060@sun>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 6 Jul 2011 10:57:05 +0100
Message-ID: <1309946225.634.165.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 10:46 +0100, Cyrill Gorcunov wrote:
> On Wed, Jul 06, 2011 at 10:25:29AM +0100, Ian Campbell wrote:
> ...
> > > 
> > > The whole series looks good to me, thanks Ian! I hope I don't
> > > miss anything, so lets wait for more feedback ;)
> > 
> > Thanks. Actually I missed the extern declaration in asm/processor.h so
> > this updated patch should be used instead:
> > 
> 
> Great, thanks Ian. Have you a chance to run this series? ;)

Yeah I booted it before I posted it. I figured that the initscripts etc
would be a sufficient test of fork() and that if it were wrong it would
fall over pretty quickly and obviously.

Ian.

