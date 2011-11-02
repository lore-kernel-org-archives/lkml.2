Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1KBWbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 18:31:22 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:57911 "HELO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750889Ab1KBWbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 18:31:21 -0400
MIME-Version: 1.0
Date: Wed, 2 Nov 2011 18:31:19 -0400
Message-ID: <CACCWSY-uTxnbUFY7_PqTWd3TZKqTuireGPqsg8kFG2i58HiPfA@mail.gmail.com>
Subject: Question about new ARP reply behaviour since 2.6.31
From: Fred Qiu <fqiu@sourcefire.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I recently found out that the kernel since version 2.6.31 does not
send ARP reply out on interface which is not the first routing
destination. This behaviour breaks things in my setup which relies on
the old behaviour. The kernel before 2.6.31 sends out ARP replies out
on the interface from which the ARP request has been received
regardless the routing table.

For example, I have a box with two interfaces, eth0 & eth1, which
connect to two different networks. The two interfaces are configured
with overlapping subnets, i.e. 192.168.0.1/24 and 192.168.0.2/24. The
first routing entry for network 192.168.0.0/24 is on eth0. Now the ARP
requests for 192.168.0.2 received by eth1 from the second network are
never being answered.

Could someone please point me to any document regarding this change?
Why is this change needed in the first place? Also any suggestion on
forcing the kernel to reply the ARP request on secondary interface
would be very helpful.

Thanks!

Fred
