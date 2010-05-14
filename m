Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab0ENQ14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:27:56 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60300 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab0ENQ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:27:54 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+W1r6I2Jbl7pPG+2QQNSEX
Date: Fri, 14 May 2010 09:27:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org,
       Linux-OMAP <linux-omap@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
       santosh.shilimkar@ti.com, Ambresh <a0393775@ti.com>,
       felipe.balbi@nokia.com, Jouni Hogander <jouni.hogander@nokia.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCHv5 0/3] Introduce the /proc/socinfo and use it to export
 OMAP data
Message-ID: <20100514162739.GY3428@atomide.com>
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
 <20100512152424.803ea807.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512152424.803ea807.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [100512 15:19]:
> 
> I'd have thought that sysfs was an appropriate place for this info. 
> Perhaps under /sys/devices/platform?  Or /sys/devices/system?  Peter's
> original patch didn't tell us where in the hierarchy the file was
> placed, nor why it was placed there, not what its contents look like. 
> But crappy changelogs are the norm :(

To me both proc and sys work, I'm fine either way.
 
> The objections stated in this email:
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg17630.html
> appear to still apply to this version of the patches?
>
> Kevin didn't explain why he said "Please export these via debugfs". 
> Tony didn't clearly explain why he said "I don't think we want to
> export unique chip identifiers by default".
 
The issue I had was with the unique silicon ID getting exposed
by default to avoid the Pentium id number situation :)

It's now handled with a Kconfig and cmdline option, basically the
same way as the id on x86. So the issues in the email thread
above are sorted out.

Regards,

Tony 
