Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab0HITic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:38:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39661 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754707Ab0HITib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:38:31 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1+HUypDWCaHd5dvKcvGKcAPG5BRtbGOxNuh/XGf20
	oxtDYfUxDennCQ
Subject: Re: [BISECTED/2.6.35+] Regression: Machine runs really slowly
 after commit f12a15be
From: Alexey Fisher <bug-track@fisher-privat.net>
To: john stultz <johnstul@us.ibm.com>
Cc: Priit Laes <plaes@plaes.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de
In-Reply-To: <1281380498.2444.2.camel@localhost.localdomain>
References: <1281186941.23274.5.camel@chi>
	 <1281380498.2444.2.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 21:38:27 +0200
Message-ID: <1281382707.22355.0.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 09.08.2010, 12:01 -0700 schrieb john stultz:
> On Sat, 2010-08-07 at 16:15 +0300, Priit Laes wrote:
> > Following commit makes my Dell Latitude D610 machine (x86_32) run really-really slow...
> > 
> > f12a15be63d1de9a35971f35f06b73088fa25c3a is the first bad commit
> > commit f12a15be63d1de9a35971f35f06b73088fa25c3a
> > Author: John Stultz <johnstul@us.ibm.com>
> 
> On Sat, 2010-08-07 at 23:04 +0200, Alexey Fisher wrote: 
> > Hallo John,
> > i have regression after commit f12a15be6.
> > With this patch my netbook (Asus Eeepc 1005) starting really slow. It
> > looks like printk comes 1/min.
> 
> Hi Priit, Alexey,
> 	Thanks so much for the testing and bisecting the issue down!
> 
> Could you both please provide the output of:
> cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
> cat /sys/devices/system/clocksource/clocksource0/available_clocksource


cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
hpet

cat /sys/devices/system/clocksource/clocksource0/available_clocksource
hpet acpi_pm 


