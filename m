Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1IRQRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 12:17:04 -0400
Received: from smtp.wifcom.cz ([77.93.192.217]:48266 "EHLO wifcom.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753239Ab1IRQRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 12:17:03 -0400
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Sep 2011 12:17:03 EDT
Message-ID: <4E7616F5.7080009@cdi.cz>
Date: Sun, 18 Sep 2011 18:06:13 +0200
From: Martin Devera <martin.devera@cdi.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: iptables 2.6.38, can kernel erroneously bypass PREROUTING ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

we have problem with high-bw router (1gbit, conntrack, nat, htb qos) 
where after some time (weeks) DNAT stops working.
I tried to include "-t raw -A PREROUTING -i eth0" an it got ZERO hits
while -i eth1 has many.
Thus DNAT (in -t nat) doesn't work but interestingly conntrack (and thus
SNAT records) is ok - packets from eth0 sems to be routed.
Only they "somehow" skip all PREROUTING chains.. But from sources
I can find no way how only eth0 pkts could skip PREROUTING but still
be routed and contracked ... Anyone has a clue ?

A didn't more investigation as I had to reboot it - it always helps.

thanks, Martin
