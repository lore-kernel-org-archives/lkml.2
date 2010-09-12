Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab0ILTE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 15:04:59 -0400
Received: from lo.gmane.org ([80.91.229.12]:53153 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab0ILTE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 15:04:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Heiko Bauke <heiko.bauke@snafu.de>
Subject: Realtek Ethernet drivers
Date: Sun, 12 Sep 2010 21:04:44 +0200
Message-ID: <20100912210444.76ebeee6@tron.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: p54abac24.dip.t-dialin.net
X-Newsreader: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kernel-Developers,

in the last few weeks I spend quite some time trying to fix a network
problem on my home server which has two Realtek onboard ethernet cards,
lspci-output:

00:0c.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC Gigabit Ethernet (rev 10)
00:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC Gigabit Ethernet (rev 10)

The problem was that sometimes one of the two cards or both obtained
«no link» status while all cables where pugged in correctly. After
unplugging the power supply and rebooting or after removing the module
r8169 and reloading it all links where up again (or maybe not).  

Searching the web I found that many other users have or had the same or
similar problems with this kind of ethernet card. Some users suggested
workarounds but none of these did work for me. Only after installing
drivers [1] as provided by Realtek my «no link» problems disappeared. 

Taking into account that the Realtek divers for RT8168 [2] and RT8169
[3] cards seem to be more reliable than the drivers in the Linux kernel
tree and that the Realtek drivers [2, 3] are distributed under the
terms of the GPL I wonder is there any good reason not to include these
drivers into the Linux main source tree?


	Regrads,

	Heiko


P.S. I am running 2.6.32-24-generic on a 32-bit Ubuntu 10.04.1 LTS box.


[1] http://www.realtek.com.tw/downloads
[3] http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=13&PFid=4&Level=5&Conn=4&DownTypeID=3&GetDown=false&Downloads=true
[2] http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=13&PFid=5&Level=5&Conn=4&DownTypeID=3&GetDown=false

-- 
-- Man könnte viele Beispiele für unsinnige Ausgaben nennen, aber keines
-- ist treffender als die Errichtung einer Friedhofsmauer. Die, die
-- drinnen sind, können sowieso nicht hinaus, und die, die draußen sind,
-- wollen nicht hinein. (Mark Twain, am. Schriftsteller, 1835-1903)


