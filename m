Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1BCV32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:29:28 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42765 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1BCV30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:29:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=fsJ39hlZU9bjpS10UNyOu4UsAKzJh/8ReDUv4HIUe3LEYQZK56nD6sRdGnK7XJAvBY
         IcKc6EuwyzCNdstPXZGYNyVR1iyFFSyzA9HwEn8fzNSC01VjNDM0JGEOJ5ZkZkImYqcz
         XZa0/OH5KeitoNPpsoGUz3V4g/6Fpt1wgPqis=
Message-ID: <4D4B1E63.7070409@gmail.com>
Date: Thu, 03 Feb 2011 22:30:11 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
User-Agent: Polo rio abaixo vai unha troita de pe, corre que te corre, quen a puidera coller...
MIME-Version: 1.0
To: brian@visionpro.com, linux-kernel@vger.kernel.org
Subject: Re: Memset very slow
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian D. McGrew wrote:

> So, my question is, can someone explain to me what is going on here?  I am
> not convinced this is a kernel problem just because a new kernel fixed it;
> but, if there were changes related to this in the kernel, then what is the
> oldest version I should be looking at to fix my issues?

changelog of BIOS:

--cut--
A07
1. Enhanced security device support

A06
1. Updated Intel Xeon?Processor 5600/3600 Series microcode to rev 10.
2. Updated Intel Xeon Processor 5500/5600 Platform Reference Code to revision P2.91.
3. Enhanced TPM remotely provision.
4. Enhance VT-d.

A05
1. Updated to the latest Intel (R) Xeon (R) Processor 5600 Series microcode

A04
1. Supported E5620, E5630, E5640, X5650, X5660, X5667, X5670, X5677, X5680, W3680 CPUs.
2. Updated Intel Xeon?500/5600 Platform Reference Code to revision P2.7
3. Removed S1 support.
4. Removed "Optional HDD fan" support.
5. Reported riser's DIMMs information(asset tag, serail number) in SMBIOS.
6. Used the same fan setting before and after S3.
7. Enhanced the compatibility with certain PCI-Express Gen1 cards.
8. Enhanced NUMA under RHEL5.3.
9. Removed HDD Acoustic support. 

A03
1. Added error detection for bad monitors or cables when entering setup menu.
2. Enhanced PCIe bar allocation.
3. Enhanced algorithm for Graphics card with multiple OPROMs.
4. Updated BIOS fan descriptions.
5. Fixed BIOS cannot boot from SATA CD/DVD when setting USB controller to "No Boot" in BIOS setup menu.

A02
1. Implemented fix for intermittant boot issue with 6.4 GT/s CPUs.
2. Added feature to display a message if the DIMM configuration is not optimal.
3. Updated Intel(R) Memory Reference Code.
4. Added microcode update revision 11 for Nehalem D0-step.
5. Fixed boot issue with RAID and ATI FireMV 2450.
6. Added TCM support.
7. Added updated IO programming.
8. Fixed possible hang condition when VT-d is enabled.
9. Moved "Optional HDD Fan" to the "Post Behavior" section in Setup.
10. Updated SMBIOS tables.
11. Added support for Windows 7.
12. Updated fan settings.
13. Corrected memory channel information in Setup.
14. Improved the allocation of system resources. 
--end--

What latest bios is sane ? Run the test again in the
OLD machine with A03, A04, and so on...

Also check numactl.

-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»
