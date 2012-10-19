Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab2JSNlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:41:46 -0400
Received: from zmc.proxad.net ([212.27.53.206]:43423 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758908Ab2JSNlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:41:45 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: linux-kernel@vger.kernel.org, bigeasy@linutronix.de, mingo@redhat.com,
        bigeasy@linutronix.de
Subject: Re: [PATCH] x86/dt: use linear irq domain for ioapic(s).
Date: Fri, 19 Oct 2012 15:40:29 +0200
Message-ID: <6899584.nNROmkLzNS@flexo>
Organization: Freebox
User-Agent: KMail/4.8.5 (Linux/3.2.0-24-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <loom.20121019T133451-621@post.gmane.org>
References: <1343890270-13007-1-git-send-email-thierry.reding@avionic-design.de> <502252C8.3090600@linutronix.de> <loom.20121019T133451-621@post.gmane.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2012 11:36:25  Fainelli wrote:
> Sebastian Andrzej Siewior <bigeasy <at> linutronix.de> writes:
> > 
> > No. You do have a compatible entry. It first appeared on the ce4100
> > CPU. If it happens to also work on the n450 then it seems to be
> > compatible with that one. "This" is documented somewhere…
> > Usually you add 'compatible = "your cpu", "generic binding"' in case
> > you need a fixup / errata whatever for "your cpu". Even if you compare
> > all hpets from Intel there is the one or other difference / errata.
> 
> Can we make sure that his hits the future 3.6 stable releases? We had to merge
> this back to your 3.6 kernel tree in order to have a functionnal CE4100 system.
> 
> Thank you!

Adding Adding Thomas, Ingo and Sebastian in CC.
--
Florian
