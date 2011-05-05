Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1EEWET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 18:04:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35392 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750853Ab1EEWES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 18:04:18 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX18F2MwLP3wFAMf7R6n/8cE48+NkcfSEwQrTKYyXIp
	eU62UdLD21O9xo
Message-ID: <4DC31EDE.2020503@gmx.de>
Date: Fri, 06 May 2011 00:04:14 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.X)
References: <4DAF6C0B.3070009@gmx.de> <20110427134613.GI32590@random.random> <4DC14474.9040001@gmx.de> <20110504143842.GK7838@random.random>
In-Reply-To: <20110504143842.GK7838@random.random>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It happened again: This time with 2.6.38.4 after 13 days uptime.
In fact it was "13 days after last boot", since this machine is
hibernated quite often. I waited only two minutes before I run
'reboot' as root.

> Please next time can you run SYSRQ+t too in addition of SYSRQ+l?

See http://pastebin.com/raw.php?i=XnXXfC40 (It seems to me SYSRQ+l
did not work at all? And does also not work on 2.6.38.5?)

see http://pastebin.com/raw.php?i=Zuv0VnUP for 'top/iotop'

> You can run also a "ps xal" to see the actual scheduler task
> state.

I had no access to my mails and forgot to run 'ps xal'. :-(

> If we understand what it is, it'll be easy to tell if it was already
> fixed in 2.6.38.4 but I doubt unless it's not related to MM.

Definitely not fixed in 2.6.38.4.

Thomas

