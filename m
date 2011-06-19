Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab1FSCeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 22:34:12 -0400
Received: from nm18.access.bullet.mail.mud.yahoo.com ([66.94.237.219]:40423
	"HELO nm18.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751992Ab1FSCeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 22:34:08 -0400
X-Yahoo-Newman-Id: 789959.76070.bm@omp1014.access.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Message-ID:Organization:User-Agent:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=3ivdfI3wqsg/O/2oPNri0bWB4o1I3LKUzOVwyhR64ZRP3QQ/iCfUUnV/EIzSlPV5SqvORWtuQtYYhVZAimebpce2YIUgFiKD+PrAbX+geiM0zVaQI3Jae61c32z5nn8y235K3jyAyfKx6FJ77vxbFe88lj40QZbJ/vPSrKf+9ME=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: tT8G3iEVM1n2xbf5cLvMj.U2oCmov4hu4CUB_NKx66992Xf
 4eKyzZJITo1iBUg.XnPsABEdC2Uewol1zgCZ21HxlMvvTfFAkMwFA.0y0Sb0
 3Jx4kfe23udfDeDJ0zkxWZJzJ0ed4qfyqZtZS.mGDyDK1kHKHoQZHjLpL60j
 N8ag8Je6BTbK8VWH5owr9NEsArMvX1AZBxEw_d64hMqElMGeYgA20B03XQoR
 DAZAcB9j7ZN1JhblbiFU2pumiBfrXMJROqL32WsX8IZB_E3hpavF48yg6Rln
 JqXHDa3PadKr7bSri_7GUVamYiV4xGFgrnqSPSIgi8fTa55HfwsH7j8IEAZH
 ObbglmWmKReWLNcguBM5WcuAgcUeUpU8mipWlXCwxAt_eReZQZtnm.49SI4U
 cpi0qBd6b_AEsEokZ_IPxzNDz6dpCrJZV3HmqpH11Ez8aq7hFLL.VZV6oTLR
 iM8Ekvxklj22v_BfREDGQemDdhjo_jKbEYmdGNkYvN4sqcgWQWci1KdoQyVP
 z8k_rw9.HQeWKP9I3Rl.UtEpUCNwGL3TrdMWX
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #37232] [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system error (SERR) for reason a1 on CPU 0
Date: Sat, 18 Jun 2011 22:34:03 -0400
Message-ID: <9766569.DLsi33Yrbe@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.6.0 (Linux/3.0-0.rc3.git5.1.fc16.x86_64; KDE/4.6.80; x86_64; ; )
In-Reply-To: <JL7O0m0yLjL.A.suC.xNS9NB@chimera>
References: <vv0uv79EvLN.A.jiC.pNS9NB@chimera> <JL7O0m0yLjL.A.suC.xNS9NB@chimera>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 12, 2011 10:30:54 PM Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.39.  Please verify if it still should be listed and let the
> tracking team know (either way).
> 
This continues in -rc3 (3.0-0.rc3.git5.1.fc16.x86_64)

[   22.675931] NMI: PCI system error (SERR) for reason a1 on CPU 0.
[  163.002909] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe48000 
[  163.002911] DMAR:[fault reason 05] PTE Write access is not set

03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] 
Network Connection

I assume both of those are separate issues, but they continue in any case.

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37232
> Subject		: [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system error (SERR) 
for
> reason a1 on CPU 0 Submitter	: Shawn Starr <shawn.starr@XXXXX>
> Date		: 2011-06-03 4:56 (10 days old)
> Message-ID	: <4478124.OuFNgaPiHS@XXXXXX>
> References	: http://marc.info/?l=linux-kernel&m=130707737616116&w=2
