Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1FJIk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:40:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34210 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752143Ab1FJIkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:40:24 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+WwxsTTduWD+afVdBsLyv455i0G6UoIbJuwnIprw
	d6Yt/aq17qzKyJ
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: non-printable characters in /proc/interrupts
Date: Fri, 10 Jun 2011 10:40:19 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39.1; KDE/4.6.3; i686; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0hd8NTp4FAf95iu"
Message-Id: <201106101040.20282.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_0hd8NTp4FAf95iu
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I've wondering about this entry at my ThinkPad T400 (kernel 2.6.39.1):

n22 ~ # grep 47: /proc/interrupts
 47:      44041      69740   PCI-MSI-edge      l=E2=96=92=EF=BF=BD=EF=BF=BD=
@=EF=BF=BDE=EF=BF=BD

I attached the output of=20
$>grep 47: /proc/interrupts > /tmp/int47
onto this email, the complete table looks like this :

n22 ~ # cat /proc/interrupts
           CPU0       CPU1      =20
  0:     605293      71393   IO-APIC-edge      timer
  1:      13432          4   IO-APIC-edge      i8042
  8:         55         64   IO-APIC-edge      rtc0
  9:       6248        509   IO-APIC-fasteoi   acpi
 12:       1389         72   IO-APIC-edge      i8042
 16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb6
 17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb7
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb8
 19:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
 20:      52881          0   IO-APIC-fasteoi   uhci_hcd:usb3
 21:        329         37   IO-APIC-fasteoi   uhci_hcd:usb4
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
 23:      30046       8743   IO-APIC-fasteoi   ehci_hcd:usb1
 40:          0          0   PCI-MSI-edge      PCIe PME
 41:          0          0   PCI-MSI-edge      PCIe PME
 42:          0          0   PCI-MSI-edge      PCIe PME
 43:          0          0   PCI-MSI-edge      PCIe PME
 44:     484163      55698   PCI-MSI-edge      ahci
 45:        750       1809   PCI-MSI-edge      eth0
 46:         94        213   PCI-MSI-edge      hda_intel
 47:      44399      70713   PCI-MSI-edge      l=E2=96=92=EF=BF=BD=EF=BF=BD=
@=EF=BF=BDE=EF=BF=BD
 48:      71969     102457   PCI-MSI-edge      iwlagn
NMI:          0          0   Non-maskable interrupts
LOC:   10167789   10321319   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
IWI:        213        200   IRQ work interrupts
RES:     289390     333102   Rescheduling interrupts
CAL:       4677       4542   Function call interrupts
TLB:      22261      16007   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:         41         41   Machine check polls
ERR:          0
MIS:          0


=2D-=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--Boundary-00=_0hd8NTp4FAf95iu
Content-Type: text/plain;
  charset="UTF-8";
  name="int47"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="int47"

 47:      44044      69743   PCI-MSI-edge      l=1A=DC=F4@=88E=C2

--Boundary-00=_0hd8NTp4FAf95iu--
