Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab0C3Lrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 07:47:43 -0400
Received: from outgoing.selfhost.de ([82.98.87.70]:40208 "EHLO
	outgoing.selfhost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab0C3Lrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 07:47:41 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Mar 2010 07:47:41 EDT
Message-ID: <4BB1E34B.5030207@darkharri.de>
Date: Tue, 30 Mar 2010 13:40:59 +0200
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100320 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.33.1 regression: sound splutters
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,

With 2.6.33.1 and 2.6.34-rc2 sound splutters for my PC. Moving
back to 2.6.29.8 makes the problem go away.

lspci:
00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) High Definition Audio Controller (rev 04)
        Subsystem: AOPEN Inc. Device 0575
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at d4340000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: <access denied>
        Kernel driver in use: HDA Intel

Can anybody reproduce this? Please mail if I can help to track
this down.


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkux40sACgkQUTlbRTxpHjcXZwCeMyvXvah8HDeRd0h6luGSP5Yy
b5kAniUhFJehUzHZGIashlGPGzw6kIW9
=tSbA
-----END PGP SIGNATURE-----
