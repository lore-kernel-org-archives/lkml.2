Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1JXOOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:14:41 -0400
Received: from lo.gmane.org ([80.91.229.12]:35397 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171Ab1JXOOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:14:40 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-15?Q?Sven_K=F6hler?= <sven.koehler@gmail.com>
Subject: dmesg full of DMAR errors
Date: Mon, 24 Oct 2011 16:17:37 +0200
Message-ID: <j83rs1$mg1$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 31-18-94-5-dynip.superkabel.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111016 Thunderbird/7.0.1
X-Enigmail-Version: 1.4a1pre
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm facing the same problems as described in
https://bugzilla.redhat.com/show_bug.cgi?id=605888

I'm not sure what the conclusion of the bugzilla discussion is:
1) you decided to not workaround the bug and I should disable VT-d instead
2) you decided to workaround the bug by blacklisting device IDs


The messages are:

DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
DRHD: handling fault status reg 2


The devices in question are:
04:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller (rev 03)
04:00.4 FireWire (IEEE 1394): Ricoh Co Ltd FireWire Host Controller (rev 03)

or
04:00.0 0805: 1180:e822 (rev 03)
04:00.4 0c00: 1180:e832 (rev 03)


Product ID 0xe832 is not mentioned in the bug. Maybe it has not been
blacklisted if you went for (2)?



Regards,
  Sven Köhler


