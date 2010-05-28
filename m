Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0E1NXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:23:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60381 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab0E1NXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:23:15 -0400
Date: Fri, 28 May 2010 14:22:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mike Chan <mike@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Arve@smtp1.linux-foundation.org,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528132244.GA25189@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <201005280041.43553.rjw@sisk.pl> <20100528001514.28e593ef@lxorguk.ukuu.org.uk> <201005280205.01561.rjw@sisk.pl> <AANLkTik-8HtTVOh3toXBZZlXYgDTFtfkm6EDYRw-UPm4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik-8HtTVOh3toXBZZlXYgDTFtfkm6EDYRw-UPm4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 05:49:36PM -0700, Mike Chan wrote:

> Even if we used the proposed QoS replacement, are there suggestions on
> how to keep the cpu idle for longer than 2 seconds in Linux without
> using suspend?

I believe that the "Maximum idle time on 32-bit is 2 seconds" issue is 
solved in recent kernels.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
