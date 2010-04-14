Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0DNIw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 04:52:29 -0400
Received: from pmx3.lnl.infn.it ([192.135.30.243]:58919 "EHLO pmx3.lnl.infn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab0DNIwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 04:52:25 -0400
Message-ID: <7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Date: Wed, 14 Apr 2010 10:51:45 +0200 (CEST)
From: Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>
To: "Tung, Chien Tin" <chien.tin.tung@intel.com>,
       Steve Wise <swise@opengridcomputing.com>
Subject: RE: Socket Direct Protocol: help (2)
Cc: Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "rolandd@cisco.com" <rolandd@cisco.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       Eric B Munson <ebmunson@us.ibm.com>
In-Reply-To: <2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Priority: 3 (normal)
X-Mailer: SuSE Linux Openexchange Server 4 - WebMail (Build 2.4160)
X-Operating-System: Linux 2.4.21-314-smp i386 (JVM 1.3.1_20)
Organization: INFN - Laboratori Nazionali Legnaro
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com> <4BC49E2B.3000804@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com> <4BC4D22A.6020700@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com>
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.14.83915 (i)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 13, 2010 10:22 PM, "Tung, Chien Tin" <chien.tin.tung@intel.com>
wrote:

> >>> Chien, does the NE020 support FMRs? I looked at the nes ofed-1.5
> >>> code
> >>> and it appears to do nothing in the map_phys_fmr functions.
> >>>
> >>
> >> We never implemented map_phys_fmr. Is it relevant to the # of SGEs?
> >>
> >No, but SDP uses FMRs. I don't think it will run without FMR support.
> >
> 
> 
> Good to know.  Thanks.
> 
> Chien
> 
> 

Hi Steve and Chien,

I understand that NE020 cards have problem with SDP connected with
map_phy_fmr (FMR stands for Fast Memory Region).
Is it possible to solve/fix this point?
If yes, have you an idea about the time that is necessary to code
development/build?
If no, can you suggest me a card that supports SDP protocol?

I work on NE020 cards from February 2010 for an INFN experimental
proposal, called REDIGO (Read out at 10 Gbits/s), about the data
acquisition and movement systems. The covergence of storage protocols
around 10 Gigabits/s Ethernet protocols shows that one way could be the
Remote Direct Memory Access (RDMA). The goals are the investigations of
latency time, the throughput, the buffer size schemes and finally the
global event building bandwidth.

Do you know if NE020 cards have problems with librdma (RDMA procedures,
in general) and / or with MPI versions?

Thank you very much,
Andrea

Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2
I-35020 - Legnaro (PD)- ITALIA
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino@lnl.infn.it			

