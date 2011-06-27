Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1F0XjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:39:25 -0400
Received: from nm2-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.66]:26824
	"HELO nm2-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755480Ab1F0Xhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:37:39 -0400
X-Yahoo-Newman-Id: 780127.45046.bm@omp1011.access.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Message-ID:Organization:User-Agent:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=XDtAjRYNdf31Q1iUAv84O6nDWMT7OnzUhT2FBLO6n2LEx4ZbzQx/W7UQ/+nZHn6supMi0B7Yyp8n2hR5naFvXgIRh0nvQujmy1IFKC7M0nkyW9eB0RG6RLRwNQqF/I3bZYEdMhhRxfkMBQ88elHtrzBL6Fkl3g6seJyekWG/Sm4=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: sk6.a3AVM1laErONXLrToYH9FQzwWISpcxU4fy4cGcHLrlO
 b4Dqaxfdf9QpZKJA7aIscQdkD5mCDf0xsormuafIqv8QmHukIFX2V2Ao48pw
 5Vhuea4SaQBrocjRwP69iMtT63pUFWkApvCLpV924pIOkZ_MLlgUL1tP05kw
 hm412dKDdyxhEzUljdFC5omVbvHG492qjIHQd3DlrOlSIJgEK_vmoCuj4Hwx
 dEAb32ZNRor6RYROpUWkW0nIYHjLyVJLaFu3Si92_Q5S7gw2QYpuaJoNdVl7
 zOUuhzYNhLRlIJ4N0BWbp9oR5UNCtJAMDu.EHOJ9olM9XAdYdmmB0J1GkNir
 g_tvQEwbV8tVOqwU1uJ20_IeCk7QSF73d3pvJncZrMllsLkmQALT6giDSbC5
 2Kc_ntC52h6R4W_V1Ad6IBuFi3lh9QRx464K35NrOxF64TJw_V8Q3.PuyLjd
 5GZWVUrQvx9zKoLdu8WrJ0YcrnAHUFcLGrVRfLg4TzMuQLITJ69yGRjPAkNk
 lW6e9waVrdeAu29pBbfqelJ8AcL12zbTTH2wAZqHK992MYjtdiMbZycs6kD0
 0d4MjiH_871Nlv9X8CfgMiQ--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #37232] [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system error (SERR) for reason a1 on CPU 0
Date: Mon, 27 Jun 2011 19:37:34 -0400
Message-ID: <2202361.0SXGgnGr4r@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.6.0 (Linux/3.0-0.rc4.git0.2.fc16.x86_64; KDE/4.6.80; x86_64; ; )
In-Reply-To: <XWjMN7gBoXK.A.MrD.8Z6BOB@chimera>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera> <XWjMN7gBoXK.A.MrD.8Z6BOB@chimera>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 26, 2011 11:23:44 PM Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.39.  Please verify if it still should be listed and let the
> tracking team know (either way).
> 
This continues in -rc4, although Fedora has a patch to try to fix some DMAR 
errors, it doesn't seem to work for me.

03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] 
Network Connection

[ 1046.002195] DMAR:[DMA Write] Request device [03:00.0] fault addr ffda6000 
[ 1046.002198] DMAR:[fault reason 05] PTE Write access is not set
[ 1048.189224] DRHD: handling fault status reg 2
[ 1048.189240] DMAR:[DMA Write] Request device [03:00.0] fault addr ffd94000 
[ 1048.189244] DMAR:[fault reason 05] PTE Write access is not set

$ uname -a
Linux segfault.sh0n.net 3.0-0.rc4.git0.2.fc16.x86_64 #1 SMP Wed Jun 22 
16:27:16 UTC 2011 x86_64 x86_64 x

Perhaps someone from Intel can comment on why this broke recently? It's not 
causing me issues, just noise in logs/dmesg.

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37232
> Subject		: [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system error (SERR) 
for
> reason a1 on CPU 0 Submitter	: Shawn Starr <shawn.starr@rogers.com>
> Date		: 2011-06-03 4:56 (24 days old)
> Message-ID	: <4478124.OuFNgaPiHS@segfault.sh0n.net>
> References	: http://marc.info/?l=linux-kernel&m=130707737616116&w=2
