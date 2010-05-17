Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab0EQL6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:58:09 -0400
Received: from mailhost.elitecore.com ([203.88.135.194]:45222 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751090Ab0EQL6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:58:07 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2010 07:58:06 EDT
Message-ID: <4BF17B0A.70309@elitecore.com>
Date: Mon, 17 May 2010 22:51:14 +0530
From: krunal <krunal.patel@elitecore.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: e100 driver not working when bridge and vlan configured.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have seen this bug in many threads also checked 
"http://www.mailinglistarchive.com/xen-users@lists.xensource.com/msg19768.html", 
but nothing works for me.

I am having 4 nics, driver for 2 nics is e1000 and 2 nics is e100.

Setup
( 192.168.1.1)br0-----------eth0
                         |-------------eth1

traffic flows through my bridge machine and i can ping 192.168.1.1, vlan 
traffic also pass through it.

I am not able to ping 192.168.1.1 using vlan interface

so i created and added vlan interfaces to bridge
( 192.168.1.1)br0-----------eth0
                         |-------------eth1
                         |-------------eth0.3
                         |-------------eth1.3

Still i am not able to ping 192.168.1.1.

I then removed eth0, and eth1 from br0
( 192.168.1.1)br0-----------eth0.3
                         |-------------eth1.3

Now I am able to ping 192.168.1.1

My kernel is linux-2.6.27.45 and e100 driver is "3.5.23-k4-NAPI" which 
comes with kernel.


Same scenario works fine with e1000 driver.

This bug is already reported and i am not able to find any patch for it.


Regards,
Krunal
