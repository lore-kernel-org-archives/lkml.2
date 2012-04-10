Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2DJRel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:34:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51992 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751495Ab2DJRej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:34:39 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/HmadU+xHHafzcfN3PBJCdK775RsOO3dC72dGvbu
	RZALrcrK0dDP9t
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: /proc/interrupts has non-printable chars in kernel 3.3.1
Date: Tue, 10 Apr 2012 19:34:33 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.1; KDE/4.8.2; i686; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_q8GhPTiaq+x8Mak"
Message-Id: <201204101934.34046.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_q8GhPTiaq+x8Mak
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

The interrrupt 47 shows (with powertop) a curious "Description" :

[@^EM-W] <interrupt>

under a stable Gentoo Linux at a Thinkpad T400  - the BIOS is the latest=20
available. FWIW I attached the output of the command  $>cat /proc/interrupts

=2D-=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--Boundary-00=_q8GhPTiaq+x8Mak
Content-Type: text/plain;
  charset="UTF-8";
  name="i"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="i"

           CPU0       CPU1      =20
  0:      37165       8908   IO-APIC-edge      timer
  1:        875        862   IO-APIC-edge      i8042
  9:      16865       1071   IO-APIC-fasteoi   acpi
 12:        283        214   IO-APIC-edge      i8042
 16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb6
 17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb7
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb8
 19:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
 20:      14517      14706   IO-APIC-fasteoi   uhci_hcd:usb3
 21:        142         36   IO-APIC-fasteoi   uhci_hcd:usb4
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
 23:     403168          2   IO-APIC-fasteoi   ehci_hcd:usb1
 40:          0          0   PCI-MSI-edge      PCIe PME
 41:          0          0   PCI-MSI-edge      PCIe PME
 42:          0          0   PCI-MSI-edge      PCIe PME
 43:          0          0   PCI-MSI-edge      PCIe PME
 44:    1033332      61889   PCI-MSI-edge      ahci
 45:      65326      84792   PCI-MSI-edge      eth0
 46:      36422      36519   PCI-MSI-edge      iwlwifi
 47:     289270     468524   PCI-MSI-edge      @=05=C7=D7
 48:        297        413   PCI-MSI-edge      snd_hda_intel
NMI:          0          0   Non-maskable interrupts
LOC:   28761071   28149530   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
IWI:          6          6   IRQ work interrupts
RTR:          0          0   APIC ICR read retries
RES:     259912     403208   Rescheduling interrupts
CAL:        538        528   Function call interrupts
TLB:     166554     187899   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:         72         72   Machine check polls
ERR:          0
MIS:          0

--Boundary-00=_q8GhPTiaq+x8Mak--
