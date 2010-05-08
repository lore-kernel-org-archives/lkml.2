Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab0EHOLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 10:11:53 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:37584 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab0EHOLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 10:11:52 -0400
Date: Sat, 8 May 2010 16:11:44 +0200
From: Nils Radtke <Nils.Radtke@Think-Future.de>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: ath5k deadlock w/ blob transfer
Message-ID: <20100508141144.GA30514@localhost>
Reply-To: Nils Radtke <Nils.Radtke@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p2pb6c5339f1005071818u489804e7ud40fe3feb5459bb8@mail.gmail.com>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> I missed the first email.  What type of machine?  System lockup
> or the connection drops?  Do you get any output on the console or
> in dmesg? (try switching to a text console before your scp test.)
> If not, any output after lockup booting with nmi_watchdog=1?

IRC, no system lockup, only driver lockup. But I avoided using wireless for
blob transfer for the reliability of the lockups, so it's a couple of months
since I deliberately crashed it.. Maybe once in a while it lead to a complete
system lockup, but treat this as rumble in my memories (and could be due to
the other BUGs reported, also)..

notebook: ACER Extensa 5220
kernels since  Linux host 2.6.32.2 #4 PREEMPT Wed Dec 30 15:19:58 CET 2009 i686 and even before
lspci:
04:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless Network Adapter (rev 01)
        Subsystem: Device 1a32:0105
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+
+FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
+<PERR- INTx-
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: <access denied>

There's another bugreport for this machine, w/ hw info: http://lkml.org/lkml/2010/2/18/104

Ok, trying to lockup the machine once more, will report back then.

  Thanks,

  Nils

