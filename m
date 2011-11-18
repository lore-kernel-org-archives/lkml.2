Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab1KRWLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:11:12 -0500
Received: from edison.jonmasters.org ([173.255.233.168]:47535 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab1KRWLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:11:10 -0500
X-Greylist: delayed 1718 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Nov 2011 17:11:10 EST
From: Jon Masters <jonathan@jonmasters.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, rusty@rustcorp.com.au,
        jcm@jonmasters.org
In-Reply-To: <20111118203548.GA17761@redhat.com>
References: <20111118203548.GA17761@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 18 Nov 2011 16:35:29 -0500
Message-ID: <1321652129.20568.595.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: depmod memory usage.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 15:35 -0500, Dave Jones wrote:
> I pulled out an older laptop last night to test something, and built
> a kernel on it.  When I did the make install part, the machine almost
> ground to a halt.
> 
> It turned out that depmod used at peak 1.7GB of memory, (the laptop only had 1GB,
> so it was swapping to the point of locking up interactivity for minutes
> at a time).  It took an hour to complete.
> 
> The config file is pretty pathological (it's a distro build, so tons of
> modules -- http://codemonkey.org.uk/junk/fedora-config-x86-64)
> 
> It's been a while since I built on a machine with this amount of memory,
> but it seems that depmod has taken a big step backwards as it used to
> cope with this just fine.
> 
> This is with the m-i-t that shipped in Fedora 16 (3.16)

I'll do some digging at the distro specific side of things. It's odd
because I've got a couple of netbooks and embedded systems with *less*
memory than 1GB that run depmod just fine. There were some memory leaks
in older versions that should not be a problem any more.

Jon.


