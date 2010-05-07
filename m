Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0EGOsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:48:01 -0400
Received: from nef2.ens.fr ([129.199.96.40]:2974 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab0EGOr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:47:59 -0400
X-Greylist: delayed 3040 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 May 2010 10:47:59 EDT
From: =?utf-8?q?=C3=89ric_Brunet?= <Eric.Brunet@lps.ens.fr>
Organization: UPMC LPS-ENS
To: linux-kernel@vger.kernel.org
Subject: Some problem with nouveau
Date: Fri, 7 May 2010 15:57:15 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32.11-99.fc12.x86_64; KDE/4.4.2; x86_64; ; )
Cc: eric.brunet@lps.ens.fr
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005071557.15728.Eric.Brunet@lps.ens.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Fri, 07 May 2010 15:57:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have HP Z400 desktop computer running in x86_64 mode with a fedora 12
installed on it. The computer has an nvidia (NV96) card, for which I am
using the nouveau driver.

Everything (meaning 2D acceleration) was working fine up to
kernel-2.6.31.12-174.2.22, and when fedora updated to 2.6.32.xxx (now
kernel-2.6.32.11-99) it stopped working. I also tried a vanilla 2.6.33.3
and it doesn't work either (I wouldn't dream bothering LKML without trying
a vanilla kernel...) Here are the symptoms:
  when X is launched, the computer reboots instantaneously to the BIOS
  greeting screen, leaving the computer in such a state that the BIOS is
  enable to work (it never reaches grub, but keeps on rebooting after a few
  seconds). Shutting down the computer is necessary to recover. I have no
  useful log as the buffer have not been flushed: /var/log/Xorg.0.log is
  found empty on the next reboot.

I filled a bug with fedora with more info (dmesg, lspci) on
  https://bugzilla.redhat.com/show_bug.cgi?id=578108
but I had zero response.

So to sum up:
        2.6.31.12 + fedora patches      is working
        2.6.32.xx + fedora patches      is crashing horribly
        2.6.33.xx vanilla               is crashing in the same way.

Does that count as a regression ? I am a little bit at a loss as how to
provide debugging information on that one.

Thanks,

        Éric Brunet
