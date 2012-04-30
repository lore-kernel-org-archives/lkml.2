Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab2D3VK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 17:10:57 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:17028 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab2D3VKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 17:10:55 -0400
Date: Mon, 30 Apr 2012 23:10:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 23/29] sparc: Use generic init_task
Message-ID: <20120430211054.GA8986@merkur.ravnborg.org>
References: <20120430194725.763322463@linutronix.de> <20120430194846.989528598@linutronix.de> <20120430203538.GA8876@merkur.ravnborg.org> <alpine.LFD.2.02.1204302239000.6271@ionos> <alpine.LFD.2.02.1204302303390.6271@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1204302303390.6271@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 11:04:39PM +0200, Thomas Gleixner wrote:
> On Mon, 30 Apr 2012, Thomas Gleixner wrote:
> > On Mon, 30 Apr 2012, Sam Ravnborg wrote:
> > > This breaks sparc build as it has the following in arch/sparc/Makefile:
> > > 
> > >     head-y                 += arch/sparc/kernel/init_task.o
> > 
> > Hrmm, I thought I had catched all of this nonsense.
> 
> Updated version below.
> 
> Thanks,
> 
> 	tglx
> 
> -------------------->
> Subject: sparc: Use generic init_task
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Mon, 30 Apr 2012 16:48:55 +0200
> 
> Same code. Use the generic version. The special Makefile treatment is
> pointless anyway as init_task.o contains only data which is handled by
> the linker script. So no point on being treated like head text.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

