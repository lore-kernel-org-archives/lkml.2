Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1LCStH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 13:49:07 -0500
Received: from lo.gmane.org ([80.91.229.12]:43721 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab1LCStF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 13:49:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Mantas M." <grawity@gmail.com>
Subject: Re: Suspend and resume on ASUS Laptops
Date: Sat, 03 Dec 2011 20:48:50 +0200
Message-ID: <jbdquj$23u$1@dough.gmane.org>
References: <1322763379.30977.33.camel@frodo> <Pine.LNX.4.44L0.1112021039460.1420-100000@iolanthe.rowland.org> <20111203024317.GA5370@ellpspace.math.ualberta.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 78-60-211-195.static.zebra.lt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
In-Reply-To: <20111203024317.GA5370@ellpspace.math.ualberta.ca>
X-Enigmail-Version: 1.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-03 04:43, Michal Jaegermann wrote:
> After doing these updates I had also to add "ath ath9k" to my list of
> SUSPEND_MODULES (which are removed and reinserted in these operations)
> or otherwise I will loose my wireless connection on a resume and a
> reboot after hibernate will silently die.  In logs I can find
> 
>  irq 17: nobody cared (try booting with the "irqpoll" option)
>  Pid: 0, comm: swapper Not tainted 3.1.2-1.fc16.x86_64 #1
>  Call Trace:
> 
> These "irq 17: nobody cared" were happening before but I could get away
> without touching ath and aht9k modules.

This should have been fixed in commit a7d5b76 (jme: fix irq storm after
suspend/resume) -- at least it worked on my own laptop (K52JT).

-- 
Mantas M.

