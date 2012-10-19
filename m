Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab2JSLpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:45:06 -0400
Received: from plane.gmane.org ([80.91.229.3]:35852 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab2JSLpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:45:02 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Fainelli <ffainelli@freebox.fr>
Subject: Re: [PATCH] x86/dt: use linear irq domain for ioapic(s).
Date: Fri, 19 Oct 2012 11:36:25 +0000 (UTC)
Message-ID: <loom.20121019T133451-621@post.gmane.org>
References: <1343890270-13007-1-git-send-email-thierry.reding@avionic-design.de> <20120806073811.GA3261@breakpoint.cc> <20120808104629.GA20296@avionic-0098.mockup.avionic-design.de> <502252C8.3090600@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 213.36.7.13 (Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:16.0) Gecko/20100101 Firefox/16.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Andrzej Siewior <bigeasy <at> linutronix.de> writes:
> 
> No. You do have a compatible entry. It first appeared on the ce4100
> CPU. If it happens to also work on the n450 then it seems to be
> compatible with that one. "This" is documented somewhere…
> Usually you add 'compatible = "your cpu", "generic binding"' in case
> you need a fixup / errata whatever for "your cpu". Even if you compare
> all hpets from Intel there is the one or other difference / errata.

Can we make sure that his hits the future 3.6 stable releases? We had to merge
this back to your 3.6 kernel tree in order to have a functionnal CE4100 system.

Thank you!
--
Florian

