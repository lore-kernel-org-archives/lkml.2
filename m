Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab1F3D6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 23:58:13 -0400
Received: from nm20-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.29]:33766
	"HELO nm20-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753072Ab1F3D6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 23:58:04 -0400
X-Yahoo-Newman-Id: 6788.85957.bm@omp1005.access.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Message-ID:Organization:User-Agent:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=lg0M6rUeNHFnvyaM3o2EwW9QsiCg4w5ddPxzR9hIjfb8z1Mg1am81Gn3Jx2VMg8IqEpFc4MaiNROJRLMbiRhTH0VMmYmX9KqeeSZ/JUKq3Um9j/XnWqDPXE8ze2LDm+ZaHqw7ya51RgnFrrjKQ4899IFihi5LVFy0YTRPD7kJ58=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: KCt_uZYVM1k2LPAU6HjFqMXVpnMOy_.HZYorPC340wvCFt5
 2xF3jg2MjRICunlnL8IzFxg27iEI_QBha8ri3GKyDh.arY0HuDCGw09PsLPy
 OByKX9CFGnlmYuuDwTVgi.IHafEW4rv8D9F1fIdZy_DwpDVQPbK1Fc6LA5cB
 gSw8NdRBKwyyAeWsj5dEEFARTt9p85Ic7j.d0yRkHJsNUVFzYmCcQN.PZaiU
 _V34qDwzkJh8tYBXD.rcyrltu2lLDsihR7kt.BVcOFu7X3o0K9MY7cALxuXY
 rLfsh17hp.jBARx2BSyrKH_DPFLMQNGmJ.Wg2s_FOJiPD61xns90uKcLo55I
 Xamt5v6F.WJpT1ri1FpHmLlWsDo6omjRTysrIWUkuIpPTDwG.TvK35Aof8Gr
 w3Hu.zYpCdil1Y_kVKkU91uH8TitZqRw7swPtAXP1WnypN0_CPjOe_5dAIRu
 m0olkWvjW_fZlc6Ni5H4xxlA38XYZWVL8m3fTuSc2yD3WAggyvuAzlqz8cbh
 WWMiXDep2US7jeK2PqI7qwDDP6gndtW4pBRIr
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #37232] [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system error (SERR) for reason a1 on CPU 0
Date: Wed, 29 Jun 2011 23:57:57 -0400
Message-ID: <4678134.li9aFGSxuF@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.6.0 (Linux/3.0-0.rc5.git0.1.fc16.x86_64; KDE/4.6.90; x86_64; ; )
In-Reply-To: <201106292132.12265.rjw@sisk.pl>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera> <2202361.0SXGgnGr4r@segfault.sh0n.net> <201106292132.12265.rjw@sisk.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>On Wednesday, June 29, 2011 09:32:12 PM Rafael J. Wysocki wrote:
> > On Sunday, June 26, 2011 11:23:44 PM Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary
> > report of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.39.  Please verify if it still should be listed and let the
> > tracking team know (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37232
> > Subject		: [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system error (SERR) for reason a1 on CPU 0
> > Submitter	: Shawn Starr <XXXX.XX@rogers.com>
> > Date		     : 2011-06-03 4:56 (24 days old)
> > Message-ID: <4478124.OuFNgaPiHS@segfault.sh0n.net>
> > References	: http://marc.info/?l=linux-kernel&m=130707737616116&w=2

>>> Thanks for the update.
>>> Rafael

Hello Rafael/Linux devs,

You can close this bug now, regression is gone now. Both the SERR and the DMAR  (coming from iwlagn)
errors are resolved.

Working in: -rc5 (Fedora rawhide 3.0-0.rc5.git0.1.fc16.x86_64)

Thanks,
Shawn.
