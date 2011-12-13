Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab1LMXDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:03:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:59032 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1LMXDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:03:08 -0500
Date: Wed, 14 Dec 2011 00:03:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@linux.intel.com>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] DEBUGFS: Automatically create parents for debugfs
 files v2
In-Reply-To: <20111213222759.GB7633@tassilo.jf.intel.com>
Message-ID: <alpine.LFD.2.02.1112132359430.3020@ionos>
References: <1323812733-7520-1-git-send-email-andi@firstfloor.org> <20111213222256.GD2618@moon> <20111213222759.GB7633@tassilo.jf.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011, Andi Kleen wrote:

> > Hi Andi, is it possible to do say kstrdup or something instead of
> 
> It's possible, just would add complexity with an additional
> error path.
> 
> > variable-size array in fn[strlen(name) + 1] ? As far as I remember
> > we already had some warnings with them at least in perf land (or
> > trace land). Or I miss something?
> 
> Not aware of any problems with tracing or perf. I like them at least.

That does not make them better. We had wreckage before and you can
just consult commit a84a79e4d3 and then find a good explanation why
your usage is safe.

Thanks,

	tglx

