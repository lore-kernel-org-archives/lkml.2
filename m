Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab0I0VT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:19:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55369 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0I0VT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ZN63m4JevoOywst3FgxVi36jA1e777Pti/YnTpR07Q4lV10wLBCpqmKiMIgvCrhdWO
         Z6AuZYzhgYPkFcMygfTw1vA2/ZNDWgLNtd7ysE6lPosX7yStSKplwvzYbhXJkzEODQno
         wuDckISXrBZfeSel7Gq53tIhqVilxdmD8O25U=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Stefan Biereigel <security@biereigel-wb.de>
Subject: Re: Interrupt latency on some 945GM platforms
Date: Tue, 28 Sep 2010 00:18:01 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.35-gentoo-r8-anarsoul; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        intel-gfx@lists.freedesktop.org, Len Brown <lenb@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <201009132336.17310.anarsoul@gmail.com> <20100924125153.4fdf0c1b@jbarnes-desktop> <4C9F262F.7030709@biereigel-wb.de>
In-Reply-To: <4C9F262F.7030709@biereigel-wb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009280018.01517.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 of September 2010 13:53:35 Stefan Biereigel wrote:

> Hello Everyone,
> just to add on to reports of this problem, there was a Thread here in
> LKML some months ago targeting the same problem (but not really
> attacking it at the Chipset driver). As I have one of those Laptops with
> a 945GM-Chipset and am stuck with the same Problem (disabled tickless
> now as a workaround and set ticks to 1000) I could maybe do some testing
> of patches.
> So what I can summarize is what the others did before: Disabling CPU1
> helps, adding nohz=off helps, changing the Clocksource afterwards helps,
> binding the Interrupt does NOT help.
> So here's the Link to the old Discussion with follow-ups, maybe you can
> get some furter information from there.
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-05/msg03696.html
> We targeted the BIOS itself as everyone in this thread happened to own
> an Phoenix BIOS with some special version string.
> best, Stefan

Yep, my laptop has Phoenix BIOS too. Btw, this BIOS has buggy DSDT (thermal 
and battery don't work reliably without patching DSDT). But I tested with and 
without patched DSDT - so my custom DSDT is not cause of bug in my case.
