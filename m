Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0HZTXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 15:23:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41567 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0HZTXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 15:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=AEDJryS9A3b9ez35T9YwB2NKY8X+tR3hSkPb+YCNXhajd3ANFaL6ySfnePyRlYM8Zu
         +10BlU21jMTatCi2ECnTNKomXL+cFJZTRzq2sVVmaVYI2es3nAE67prO5gqqEtlVDb8e
         QkDcYoZf0krco63T/3pB6KiiulV7SONIitc6U=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: i915: 2.6.36-rc2 hoses my Intel display
Date: Thu, 26 Aug 2010 21:23:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2; KDE/4.4.5; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
References: <20100823110145.08eb72fd@bike.lwn.net>
In-Reply-To: <20100823110145.08eb72fd@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008262123.41226.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 23 sierpnia 2010 o 19:01:45 Jonathan Corbet wrote:
> So I decided to fire up -rc2 today to see what would happen...the
> results are best described by the attached images.  Something is
> clearly scrambled between my hardware and the i915 driver.  Display with X
> is hosed, but things go weird before X gets a chance to run (it is worth
> noting that the initial output from the kernel is legible).
> 
> FWIW, my hardware is:
> 
> 00:02.1 Display controller: Intel Corporation 82Q35 Express Integrated
> Graphics Controller (rev 02) Subsystem: Dell OptiPlex 755
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx- Status: Cap+ 66MHz- UDF- FastB2B+
> ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 	Region 0: Memory at fea80000 (32-bit, non-prefetchable) [size=512K]
> 	Capabilities: [d0] Power Management version 2
> 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 NoSoftRst- PME-Enable- DSel=0
> DScale=0 PME-
> 
> What else can I provide to help track this one down?

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=17151
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
