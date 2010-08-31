Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab0HaING (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:13:06 -0400
Received: from postin.uv.es ([147.156.1.90]:33886 "EHLO postin.uv.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab0HaIND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:13:03 -0400
X-Greylist: delayed 2012 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Aug 2010 04:13:03 EDT
Message-ID: <4C7CB18D.4020601@postal.uv.es>
Date: Tue, 31 Aug 2010 09:38:53 +0200
From: Enrico Bandiello <enban@postal.uv.es>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20091109 Thunderbird/2.0.0.22 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Kan-Ru Chen <ckanru@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Enrico Bandiello <enban@alumni.uv.es>
Subject: Re: [Bug #16307] i915 in kernel 2.6.35-rc3, high number of wakeups
References: <c1_O4wHrlB.A.63.mbueMB@chimera> <ByD_7B96czP.A.kdD.pgueMB@chimera> <AANLkTi=bLAr=9E6-nfn8r_qGNfxYCXADoA0M9PzWHLmy@mail.gmail.com>
In-Reply-To: <AANLkTi=bLAr=9E6-nfn8r_qGNfxYCXADoA0M9PzWHLmy@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Userflux: Whitelisted rcpt enban@alumni.uv.es. User email not accounted
X-RelayDelay-Mem: Whitelisted relay grajo.ci.uv.es [147.156.0.253]. Not delayed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 04:19 AM, Kan-Ru Chen wrote:

> Same with v2.6.36-rc3
>
> $ sudo powertop -d -t 20
> ...
> Wakeups-from-idle per second : 196.2    interval: 20.0s
> no ACPI power usage estimate available
> Top causes for wakeups:
>    25.4% ( 59.6)   [i915@pci:0000:00:02.0]<interrupt>

I can confir this behaviour until 2.6.32-rc2. Couldn't try with -rc3 
because compilation exited with error on my laptop...
