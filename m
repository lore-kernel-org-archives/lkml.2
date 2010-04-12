Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0DLIhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:37:48 -0400
Received: from pmx3.lnl.infn.it ([192.135.30.243]:42031 "EHLO pmx3.lnl.infn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab0DLIhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:37:47 -0400
X-Greylist: delayed 1339 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Apr 2010 04:37:47 EDT
Message-ID: <2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Date: Mon, 12 Apr 2010 10:14:45 +0200 (CEST)
From: Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
       rolandd@cisco.com, peterz@infradead.org, pavel@ucw.cz, mingo@elte.hu,
       Eric B Munson <ebmunson@us.ibm.com>,
       Steve Wise <swise@opengridcomputing.com>
Subject: Socket Direct Protocol: help
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Priority: 3 (normal)
X-Mailer: SuSE Linux Openexchange Server 4 - WebMail (Build 2.4160)
X-Operating-System: Linux 2.4.21-314-smp i386 (JVM 1.3.1_20)
Organization: INFN - Laboratori Nazionali Legnaro
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.12.80015 (i)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning,

I'm testing some Neteffect cards (Intel code E10G81GP - Neteffect
NE020.LP.1.SSR).
PC has Linux| (kernel version) 2.6.18-164.15.1.el5 | x86_64 x86_64
x86_64 GNU/Linux.

In this phase, I measure the bandwidth with the netserver/nerperf
(version netperf-2.4.5) ad hoc tests.
They work fine with TCP protocol - as OFED 1.5.1 example programs - and
they have some problems with SDP one.

I'm trying test with the command lines below:

server: LD_PRELOAD=/usr/local/lib64/libsdp.so netserver

client: LD_PRELOAD=/usr/local/lib64/libsdp.so netperf -H server_address
-c -C
-- -m 65536

The /etc/libsdp.conf file contains rules below:
use both listen * *:*
use both connect * *:*
log min-level 9 destination file libsdp.log

Client displays "Connection error: Can not allocate memory" and the
connection fails.
(original text on client log file:libsdp Error connect: failed for SDP
fd:6 with error:Cannot allocate memory)

The library path is:
/usr/local/lib64/libsdp.so


Could someone explain me how LD_PRELOAD environment variable must be
set?
I don't understand why the test work with TCP and not with SDP.
Could I work with wrong Linux kernel environment or parameters?

I don't know if there is a specific mailing list for SDP so I ask you
help.

Thank you very much,
Andrea 







Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2
I-35020 - Legnaro (PD)- ITALIA
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino@lnl.infn.it			

