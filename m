Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab1FCFCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:02:48 -0400
Received: from nm27.access.bullet.mail.mud.yahoo.com ([66.94.237.92]:43879
	"HELO nm27.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751343Ab1FCFCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:02:47 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jun 2011 01:02:47 EDT
X-Yahoo-Newman-Id: 791435.14033.bm@omp1002.access.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:Message-ID:Organization:User-Agent:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=oAViIAZsHb3fDOXlE4eD/HOakV3BQWhcIgoIr3oDQmI5LQAzwWAGyRRqrlQUewfdVWfXfWYrF88mBcF6QS2bdxaQlF7HK7Mq9m6nm6j/Xmplm167zJH64W3TbtT6DTKm/GyA42glKfN6tAV9He09gE8RKDlcaFLmyYPPXjtNl7w=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: IymqwY8VM1mo9vrKjFZEIekAxu9APuKn.2S70vygrhndyhF
 ThbLWFbCIiq4gc7fjGAxWKdUyxSG2Thd4l_4UBU4.iKr3vkzQCIjN07iUWaP
 WBosxk1FdJrK.uzVEvuMf48bnB0Mz5b8.UbO.Lb9Eb0ao_BI_gACmPg31TvO
 mPFV8mb2lVawYDDQPyBTmzim.mKgPm8kbHwBjiZurRQOAksGnpuHoajAagOq
 KYRDeIv29oLzJNCxxRqyZKo1MnIkIaEOizSAuszLoAu_ehHWcM0cgtyfl4KZ
 6B7i.Pl4RVrVaD_vzaRQ4jKo.YiS.3n2PRxfKCVHnCnEqPyH.gNQxcOF6rtG
 45B__5iyBATIPkykSkLQkQAFalm3Wk.I5WQRtww--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system error (SERR) for reason a1 on CPU 0
Date: Fri, 03 Jun 2011 00:56:02 -0400
Message-ID: <4478124.OuFNgaPiHS@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.6 rc1 (Linux/3.0.0-0.rc1.git0.1.fc16.x86_64; KDE/4.6.80; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Installing Fedora rawhide's latest build of 3.0 (3.0.0-0.rc1.git0.1.fc16.x86_64)  I am getting lots of errors

Looks like something is seriously regressed from 2.6.39 -> 3.0-rc1.git0. Anyone have ideas, I will be tracking kernels as they get pushed into rawhide in Fedora.

Device in question appears to be:

03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] Network Connection

Interestingly, in 2.6.3X the WiFi led was flashing on/off even when no traffic was occuring, now it is showing correct behavour, only flashes LED when there is traffic/beacons.

Thanks, 
Shawn.

-- snip --

[   19.395120] e1000e 0000:00:19.0: irq 49 for MSI/MSI-X
[   19.546959] NMI: PCI system error (SERR) for reason a1 on CPU 0.
[   19.546997] Dazed and confused, but trying to continue
[   19.547043] DRHD: handling fault status reg 3
[   19.547046] DMAR:[DMA Write] Request device [03:00.0] fault addr ffd76000 
[   19.547047] DMAR:[fault reason 05] PTE Write access is not set
[   19.783597] DRHD: handling fault status reg 2
[   19.783602] DMAR:[DMA Write] Request device [03:00.0] fault addr fff64000 
[   19.783603] DMAR:[fault reason 05] PTE Write access is not set
[   21.154269] DRHD: handling fault status reg 2
[   21.154274] DMAR:[DMA Write] Request device [03:00.0] fault addr ffed2000 
[   21.154275] DMAR:[fault reason 05] PTE Write access is not set
[   40.004255] DRHD: handling fault status reg 2
[   40.004263] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe48000 
[   40.004265] DMAR:[fault reason 05] PTE Write access is not set
[   41.369730] DRHD: handling fault status reg 2
[   41.369735] DMAR:[DMA Write] Request device [03:00.0] fault addr ffd1a000 
[   41.369736] DMAR:[fault reason 05] PTE Write access is not set
[   70.004823] DRHD: handling fault status reg 2
[   70.004838] DMAR:[DMA Write] Request device [03:00.0] fault addr fff1a000 
[   70.004841] DMAR:[fault reason 05] PTE Write access is not set
[   71.372381] DRHD: handling fault status reg 2
[   71.372394] DMAR:[DMA Write] Request device [03:00.0] fault addr ffc3c000 
[   71.372397] DMAR:[fault reason 05] PTE Write access is not set
[  110.005762] DMAR:[DMA Write] Request device [03:00.0] fault addr ffdba000 
[  110.005765] DMAR:[fault reason 05] PTE Write access is not set
[  111.374123] DRHD: handling fault status reg 2
[  111.374131] DMAR:[DMA Write] Request device [03:00.0] fault addr fff36000 
[  111.374133] DMAR:[fault reason 05] PTE Write access is not set
[  160.005420] DRHD: handling fault status reg 2
[  160.005435] DMAR:[DMA Write] Request device [03:00.0] fault addr ffeac000 
[  160.005439] DMAR:[fault reason 05] PTE Write access is not set
[  161.372133] DRHD: handling fault status reg 2
[  161.372147] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe00000 
[  161.372151] DMAR:[fault reason 05] PTE Write access is not set
[  173.368688] DRHD: handling fault status reg 2
[  173.368694] DMAR:[DMA Write] Request device [03:00.0] fault addr ffd76000 
[  173.368695] DMAR:[fault reason 05] PTE Write access is not set
[  173.738474] DRHD: handling fault status reg 2
[  173.738488] DMAR:[DMA Write] Request device [03:00.0] fault addr ffea4000 
[  173.738492] DMAR:[fault reason 05] PTE Write access is not set
[  220.003572] DRHD: handling fault status reg 2
[  220.003587] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe5a000 
[  220.003590] DMAR:[fault reason 05] PTE Write access is not set
[  222.177811] DRHD: handling fault status reg 2
[  222.177825] DMAR:[DMA Write] Request device [03:00.0] fault addr ffee2000 
[  222.177828] DMAR:[fault reason 05] PTE Write access is not set
[  260.004203] DRHD: handling fault status reg 2
[  260.004218] DMAR:[DMA Write] Request device [03:00.0] fault addr fff38000 
[  260.004222] DMAR:[fault reason 05] PTE Write access is not set
[  262.222674] DRHD: handling fault status reg 2
[  262.222688] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe5c000 
[  262.222692] DMAR:[fault reason 05] PTE Write access is not set
[  320.003247] DRHD: handling fault status reg 2
[  320.003262] DMAR:[DMA Write] Request device [03:00.0] fault addr fff62000 
[  320.003265] DMAR:[fault reason 05] PTE Write access is not set
[  322.428702] DRHD: handling fault status reg 2
[  322.428716] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe34000 
[  322.428720] DMAR:[fault reason 05] PTE Write access is not set
[  337.694368] DRHD: handling fault status reg 2
[  337.694382] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe58000 
[  337.694386] DMAR:[fault reason 05] PTE Write access is not set
[  400.003153] DRHD: handling fault status reg 2
[  400.003168] DMAR:[DMA Write] Request device [03:00.0] fault addr ffef0000 
[  400.003171] DMAR:[fault reason 05] PTE Write access is not set
[  402.199511] DRHD: handling fault status reg 2
[  402.199525] DMAR:[DMA Write] Request device [03:00.0] fault addr ffdea000 
[  402.199528] DMAR:[fault reason 05] PTE Write access is not set

