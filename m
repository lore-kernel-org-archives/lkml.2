Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab0GHX6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:58:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37871 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab0GHX6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:58:13 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Author: YOSHIFUJI Hideaki" <yoshfuji@linux-ipv6.org>,
       "Christian Casteyde" <casteyde.christian@free.fr>,
       "David S. Miller" <davem@davemloft.net>,
       "Jan Engelhardt" <jengelh@medozas.de>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.InD.vNmNMB@chimera>
Subject: [Bug #16187] Carrier detection failed in dhcpcd when link is up
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16187
Subject		: Carrier detection failed in dhcpcd when link is up
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-06-12 15:15 (27 days old)
First-Bad-Commit: http://git.kernel.org/linus/10708f37ae729baba9b67bd134c3720709d4ae62
Handled-By	: Andrew Morton <akpm@linux-foundation.org>


