Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1BUThe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:37:34 -0500
Received: from www.tglx.de ([62.245.132.106]:55610 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab1BUThd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:37:33 -0500
Date: Mon, 21 Feb 2011 20:37:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
cc: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] PRUSS UIO driver support
In-Reply-To: <20110221193316.GC2773@local>
Message-ID: <alpine.LFD.2.00.1102212035280.2701@localhost6.localdomain6>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com> <201102181644.17634.arnd@arndb.de> <alpine.LFD.2.00.1102181713480.2701@localhost6.localdomain6> <201102181731.05644.arnd@arndb.de> <alpine.LFD.2.00.1102181802580.2701@localhost6.localdomain6>
 <B85A65D85D7EB246BE421B3FB0FBB593024B83C108@dbde02.ent.ti.com> <20110219183427.GG4684@local> <B85A65D85D7EB246BE421B3FB0FBB593024B83C20F@dbde02.ent.ti.com> <20110221193316.GC2773@local>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Hans J. Koch wrote:
> On Mon, Feb 21, 2011 at 09:27:47AM +0530, TK, Pratheesh Gangadhar wrote:
> > and all interrupts except IRQ_TINT1_TINT34 is set to edge trigger mode (line 160).
> 
> Is that really needed? Level triggered interrupts should certainly be
> preferred if possible.

Nonsense. If you have a sane interrupt controller which latches the
edge transitions even when masked, edge type interrupts are perfectly
fine.

Thanks,

	tglx
