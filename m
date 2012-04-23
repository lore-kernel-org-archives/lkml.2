Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab2DWIOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 04:14:44 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:37012
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab2DWIOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 04:14:43 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh2a8h668h839h93fhd24hd2bh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Watchdog settimeout causes an error condition
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Wim Van Sebroeck <wim@iguana.be>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Apr 2012 13:40:39 +0530
Message-ID: <1335168639.11826.7.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new watchdog framework of settimeout causes an error condition for
the DA9052/53 PMIC since watchdog ping gets called upon applying the new
watchdog window and in the DA9052/53 PMIC we have a minimum time for the
watchdog window called TWDMIN. A write to the watchdog before this
elapsed time - TWDMIN - cause an error.

Can this be get fixed in the new framework?

Regards,
Ashish
  


