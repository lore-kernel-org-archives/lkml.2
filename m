Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab1GELPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:15:31 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:57632 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab1GELPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:15:30 -0400
Date: Tue, 5 Jul 2011 15:15:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [Q x86-64] on kernel_eflags
Message-ID: <20110705111525.GR17941@sun>
References: <20110705104742.GO17941@sun>
 <1309863656.634.111.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309863656.634.111.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 12:00:56PM +0100, Ian Campbell wrote:
...
> 
> I posted http://lkml.org/lkml/2010/2/9/155 to switch to the hardcoded
> version for 64 bit too. Is it worth my rebasing and reposting that?

I think so.

	Cyrill
