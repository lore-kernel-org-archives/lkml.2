Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab0KHJwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 04:52:13 -0500
Received: from www.tglx.de ([62.245.132.106]:54297 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab0KHJwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 04:52:12 -0500
Date: Mon, 8 Nov 2010 10:51:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Thomas Meyer <thomas@m3y3r.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36: kernel panic in cascade (Fatal exception in interrupt)
In-Reply-To: <201011080014.33354.thomas@m3y3r.de>
Message-ID: <alpine.LFD.2.00.1011081047500.2900@localhost6.localdomain6>
References: <201011032334.30662.thomas@m3y3r.de> <201011080014.33354.thomas@m3y3r.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010, Thomas Meyer wrote:
> > 
> > [   300.000697] Pid: 0, comm: kworker/0:0 Not tainted 2.6.36 #2 MS-7250/MS-7250
> > [   300.000815] RIP: 0010:[<ffffffff8105faf4>]  [<ffffffff8105faf4>] cascade+0x54/0x7a

Can you please enable

CONFIG_DEBUG_OBJECTS
CONFIG_DEBUG_OBJECTS_FREE
CONFIG_DEBUG_OBJECTS_TIMERS
and set CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT to 1

That should give us more useful data.

Thanks,

	tglx
