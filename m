Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab0E1M1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 08:27:17 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26973 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab0E1M1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 08:27:15 -0400
Message-ID: <4BFFBBE6.50604@nokia.com>
Date: Fri, 28 May 2010 15:49:42 +0300
From: Igor Stoppa <igor.stoppa@nokia.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: ext Theodore Tso <tytso@mit.edu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>	<20100527220949.GB10602@srcf.ucam.org>	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>	<20100527223605.GB11364@srcf.ucam.org>	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>	<20100528043114.GC26177@thunk.org>	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk> <06439EEF-9404-45DC-AB37-5CC0486CCF6C@mit.edu>
In-Reply-To: <06439EEF-9404-45DC-AB37-5CC0486CCF6C@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2010 12:26:35.0714 (UTC) FILETIME=[037AC220:01CAFE61]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Theodore Tso wrote:

> I've seen very hard to debug situations  with Maemo where users are essentially asked to uninstall all their applications, and then install them back one at a time, waiting several hours between each install for a charge/discharge cycle, to figure out which application was waking up the system so !@#@! much while the screen was turned off.   And, when the periodic wakeups are faster than the refresh time of powertop, no, powertop won't help you find the crapplication.   If you think that's acceptable, fine --- we'll see who wins in the marketplace, and who gets blamed for producing a crappy platform --- the incompetent application programmer, or the platform supplier.
>   
Those apps were from an experimental repository, which is not enabled by 
default in stock SW.

Of course tools can be improved, but if someone decides to run sw which 
is clearly under heavy development, i see little point in complaining 
that it might not work as expected.

igor
