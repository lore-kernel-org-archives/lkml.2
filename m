Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab1JDUCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:02:00 -0400
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:52608 "HELO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933524Ab1JDUB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:01:59 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Oct 2011 16:01:59 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: big picture UDP/IP performance question re 2.6.18  -> 2.6.32
Date: Tue, 4 Oct 2011 15:54:50 -0400
Message-ID: <D3F292ADF945FB49B35E96C94C2061B91400C5F6@nsmail.netscout.com>
In-Reply-To: <6.2.5.6.2.20111002110545.03a82460@binnacle.cx>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: big picture UDP/IP performance question re 2.6.18  -> 2.6.32
Thread-Index: AcyBGLfQ3eq3+PsLTXuSd0Pmkqrv3ABtYrTA
References: <6.2.5.6.2.20111001215241.03a7ed48@binnacle.cx> <1317540066.3802.32.camel@edumazet-laptop> <6.2.5.6.2.20111002110545.03a82460@binnacle.cx>
From: "Loke, Chetan" <Chetan.Loke@netscout.com>
To: <starlight@binnacle.cx>, "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, "netdev" <netdev@vger.kernel.org>,
        "Willy Tarreau" <w@1wt.eu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>
X-OriginalArrivalTime: 04 Oct 2011 19:54:50.0639 (UTC) FILETIME=[7A2B21F0:01CC82CF]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18424.004
X-TM-AS-Result: No--2.540100-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sometimes I think it might be nice to run without
> an OS at all :-)
> 
> We are looking at various kernel bypass approaches
> for receiving packets and it's in my mind that
> one of these may get us to running on newer
> kernels without giving up performance.
> 

If permissible in your environment, try running PACKET:tpacket_v3.

Also, I always wondered about the following in the output of:

net/ptype
dada          edsa_rcv+0x0/0x246
001b          dsa_rcv+0x0/0x225

and so when I'm fine tuning apps in virtual environments I nuke the
above during kernel compilation.


Chetan Loke
