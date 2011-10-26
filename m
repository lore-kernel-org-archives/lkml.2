Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab1JZEUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 00:20:11 -0400
Received: from lo.gmane.org ([80.91.229.12]:56607 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab1JZEUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 00:20:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Gene Smith <gds@chartertn.net>
Subject: wifi iwlagn fails to authenticate after wake from suspend
Date: Wed, 26 Oct 2011 00:15:01 -0400
Message-ID: <j881g5$tdf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 24-158-184-117.dhcp.jcsn.tn.charter.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now after upgrade to Ubuntu 11.10 when resume from suspend, wifi fails 
to reconnect saying waiting for authentication. When I use older kernel, 
2.4.38 instead of the new 3.0.0, it still works OK. If using ethernet, 
after wake from suspend it always works OK.

More details on this bug are here
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/880648
and here
https://bugzilla.redhat.com/show_bug.cgi?id=7374

Tried new Ubuntu kernel 3.1-rc10 did not help. Did not try an alternate 
kernel with Fedora 15.

The common failure messages seen with Ubuntu and Fedora is this:

<info> (wlan0): device state change: need-auth -> failed (reason 
'no-secrets') [60 120 7]
Oct 24 01:20:00 hplt NetworkManager[1016]: <warn> Activation (wlan0) 
failed for access point (dbnet)

After this occurs, no further attempt to authenticate wifi occur and a 
red X appears over the wifi icon. I must then use ethernet (or reboot).

-gene


