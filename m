Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab0DHQRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:17:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:41469 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758583Ab0DHQRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:17:32 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+61fQ3wWG6hcdLVWoLudqMdkKi+TTxpkbI3Mhvo+
	U2ivKkU13n3Ck4
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: my KDE-4.4.2 Battery Monitor ppplet dislikes the ACPI changes in 2.6.34-rc3 betweeen f5284e7..cf90bfe
Date: Thu, 8 Apr 2010 18:17:29 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc3-00406-gcf90bfe; KDE/4.4.2; i686; ; )
References: <201004081812.10656.toralf.foerster@gmx.de>
In-Reply-To: <201004081812.10656.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004081817.29561.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Toralf Förster wrote at 18:12:09
> because now it tells me that my ThinkPad T400 has 0 cpus and 0 batteries
> ...

FWIW : 

tfoerste@n22 ~/tmp $ grep "ACPI E" dmesg-2.6.34-rc3-00406-gcf90bfe
ACPI Error: Null Object! Obj=(null) State=f676bc00 Num=0 
(20100121/dswstate-183)
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.LPC_.EC__.GBIF] (Node f70d4e28), AE_BAD_PARAMETER
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.LPC_.EC__.BAT0._BIF] (Node f70d4d60), AE_BAD_PARAMETER
ACPI Exception: AE_BAD_PARAMETER, Evaluating _BIF (20100121/battery-405)
thinkpad_acpi: ThinkPad ACPI Extras v0.24


-- 
MfG/Sincerely
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

