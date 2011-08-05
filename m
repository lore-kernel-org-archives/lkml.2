Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1HEMT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 08:19:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46446 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab1HEMT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 08:19:58 -0400
Date: Fri, 5 Aug 2011 14:18:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Pirko <jpirko@redhat.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [forcedeth bug] Re: [GIT] Networking
Message-ID: <20110805121855.GC13055@elte.hu>
References: <20110722.073339.1236244143490935644.davem@davemloft.net>
 <20110801151308.GA31256@elte.hu>
 <20110804215354.GA7056@elte.hu>
 <20110805102239.GB1928@minipsycho.orion>
 <20110805102903.GF2420@elte.hu>
 <20110805112557.GD1928@minipsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805112557.GD1928@minipsycho.orion>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Pirko <jpirko@redhat.com> wrote:

> >> Is DEV_HAS_VLAN set in id->driver_data (L5344) ?
> >
> >How do i tell that without hacking the driver?
> 
> look in dmesg for line like:
> "forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt gbit lnktim msi
> desc-v3"
> 
> if "vlan" is there, DEV_HAS_VLAN is set

[    3.534489] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3

Note, this is a pretty old system with an old nvidia chipset and 
on-board ethernet:

00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (250ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at da100000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at d000 [size=8]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable+ DSel=0 DScale=0 PME-

Thanks,

	Ingo
