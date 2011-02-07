Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1BGXi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:38:29 -0500
Received: from www.tglx.de ([62.245.132.106]:37278 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab1BGXi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:38:28 -0500
Date: Tue, 8 Feb 2011 00:38:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tony Luck <tony.luck@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jes Sorensen <jes@sgi.com>
Subject: Re: [patch 0/8] ia64: Convert irq_chips to new functions
In-Reply-To: <AANLkTimd37W_PBtQhhHf3YHj_ms6d-g7F6EQVACNigc+@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1102080037170.31804@localhost6.localdomain6>
References: <20110205193740.964969119@linutronix.de> <AANLkTimd37W_PBtQhhHf3YHj_ms6d-g7F6EQVACNigc+@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1069547887-1297121900=:31804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1069547887-1297121900=:31804
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Mon, 7 Feb 2011, Tony Luck wrote:

> On Sat, Feb 5, 2011 at 11:44 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > The following series converts the interrupt chips to the new
> > functions.Compile tested only.
> 
> I see a new warning while building:
> 
> arch/ia64/sn/kernel/irq.c:427: warning: ‘force_interrupt’ defined but not used

Oops
 
> since you deleted the only use of this function.
> sn_force_interrupt_flag doesn't
> seem to be useful either once this patch has been applied.
 
Agreed.

> Apart from that it all seems to build and boot with no problems on my
> machine.  I haven't tested on SGI sn2 system (where you've made
> a moderately big change).  It'd be nice to get an Ack from there.

That might take a while. I fear Jes is skiing this week, IIRC.

Thanks,

	tglx
---1463795968-1069547887-1297121900=:31804--
