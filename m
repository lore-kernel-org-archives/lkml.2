Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1EEMQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:16:21 -0400
Received: from mailout.rz.uni-frankfurt.de ([141.2.22.233]:44474 "EHLO
	mailout.rz.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1EEMQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:16:20 -0400
Message-ID: <4DC2A149.1080008@gmx.de>
Date: Thu, 05 May 2011 15:08:25 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
References: <4DAF6C0B.3070009@gmx.de> <20110427134613.GI32590@random.random> <4DC14474.9040001@gmx.de> <20110504143842.GK7838@random.random>
In-Reply-To: <20110504143842.GK7838@random.random>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The machine kept running until two hours ago. Then system load
started to increase. Slowly but constantly. I waited for about
an hour before I rebooted.

It started while I was reading manpages and I could not quit
pressing 'q'. I was unable to open new terminals (in fact
the terminals opened, but never reached a shell prompt).

Already open terminals allowed entering commands, some worked
others hung. Tab completion in shells reproduceably hung them.
While I pressed SysRq-l and SysRq+t several times, nothing at
all has been written to disk. No lines in /var/log/messages
after sysload started to increase.

A terminal already running "watch -n1 'dmesg+hrts | uniq -c |
tail -n58'" showed:  http://pastebin.com/raw.php?i=2cC53raT
('dmesg+hrts' translates timestamps into a wallclocktime.)

Two other terminals were running 'top' and 'iotop':
http://pastebin.com/raw.php?i=Mwj2mGdw

I tried to run 'ps xal' but that also hung the terminal. I'm
sorry, but that's all I could get. Please keep in mind that
this particular machine was (and again is), in spite of the
threads subject, running 2.6.38.2

Thomas
