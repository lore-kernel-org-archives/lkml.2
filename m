Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0LGRmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 12:42:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47371 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0LGRmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 12:42:21 -0500
Date: Tue, 7 Dec 2010 09:41:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: bugs/regressions: report in LKML or in bugzilla?
Message-Id: <20101207094121.364745f9.randy.dunlap@oracle.com>
In-Reply-To: <201012071639.58884.Martin@lichtvoll.de>
References: <201012071639.58884.Martin@lichtvoll.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010 16:39:46 +0100 Martin Steigerwald wrote:

> Hi!
> 
> I reported some regressions to bugzilla that did not receive any 
> attentation so far:
> 
> [Bug 23792] New: openvpn: failure to unregister tap1 device, possibly 
> related to some netconsole issue
> https://bugzilla.kernel.org/show_bug.cgi?id=23792
> 
> [Bug 23642] New: easycap driver fails to compile in 2.6.37-rc3
> https://bugzilla.kernel.org/show_bug.cgi?id=23642
> 

That one has received attention.  I commented on it and I have posted
a patch that fixes that particular build problem.

> 
> A participant of a linux performance training I hold found a bug with 
> window scaling which did not receive any reply as well:
> 
> Bug 20312 -  System freeze with multiples of 32 in 
> /proc/sys/net/ipv4/tcp_adv_win_scale
> https://bugzilla.kernel.org/show_bug.cgi?id=20312
> 
> 
> Is it better to report on LKML? I have the impression that bug reports 
> onto the mailinglist are more easily recognized.

They are generally more visible and get more attention if they are posted
on an appropriate mailing list.  #20312, e.g., should be posted on the
netdev mailing list (netdev@vger.kernel.org)
Probably same for #27392.


> I also find it difficult to find the right component when reporting a problem 
> in bugzilla. Thus reports might not go to the right persons.
> 
> Please advice.

Bugs that are posted to LKML usually are added to the kernel bugzilla
by one of the bugzilla maintainers.  They would also select the component,
so you could just try that route to see if it works better.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
