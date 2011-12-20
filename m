Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1LTHtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 02:49:32 -0500
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:4578 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947Ab1LTHt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 02:49:27 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAAc88E5tg0Xn/2dsb2JhbABDq3KBBoFyAQEFJxMcIxAIAxguFCUDIYgPtzcTi3kElH6SMg
Date: Tue, 20 Dec 2011 08:49:24 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Josh Cartwright <joshc@linux.com>
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: oops during modprobe (3.2.0-rc6+)
Message-ID: <20111220074924.GG23376@infomag.iguana.be>
References: <20111217213645.GQ12099@charite.de> <20111220023550.GB9308@joshcartwright.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220023550.GB9308@joshcartwright.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> (CC'ing linux-watchdog)
> 
> On Sat, Dec 17, 2011 at 10:36:45PM +0100, Ralf Hildebrandt wrote:
> > Todya I pulled 3.2.0-rc6+ from git and built it for my machine. After
> > booting I found this in dmesg:
> > 
> > ...
> > [    6.322632] bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.1.11 (July 20, 2011)
> > [    6.324608] hpwdt 0000:01:04.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> > [    6.324680] hpwdt: New timer passed in is 30 seconds.
> > [    6.324725] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)

Thomas has created a fix for this. It will be added to the linux-next branch of the linux-watchdog tree today.

Kind regards,
wim.

