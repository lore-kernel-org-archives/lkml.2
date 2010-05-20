Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0ETEyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 00:54:32 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:58070 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab0ETEy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 00:54:28 -0400
Date: Thu, 20 May 2010 00:53:39 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-reply-to: <20100514154905.GA6681@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.1005200025360.2921@localhost.localdomain>
References: <20100513160117.GB22238@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
 <20100513171639.GA23708@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005131017070.3711@i5.linux-foundation.org>
 <20100513181002.GB23708@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005131253310.3711@i5.linux-foundation.org>
 <m1aas2kjb6.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1005140751300.3711@i5.linux-foundation.org>
 <20100514153842.GA6398@srcf.ucam.org>
 <alpine.LFD.2.00.1005140841320.3711@i5.linux-foundation.org>
 <20100514154905.GA6681@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, even with Windows, I do wonder if they have things like cut-off 
> dates for trusting ACPI. We certainly do.

Upstream Linux's main ACPI cutoff, CONFIG_ACPI_BLACKLIST_YEAR
has been disabled by default since Linux-2.6.9.
So if a platform claims to support ACPI,
upstream Linux has run in ACPI mode on it for many years.

The idea was that we'd harvest and debug ACPI failures
using the upstream kernels, while the distros could play it safe
and set the cutoff to 1999 or even later.

But a funny thing happened a few years ago.
The distros stopped setting this cutoff, and nobody complained.
Of course, it could simply be that few people are using machines
that old anymore...

In any case, I expect that versions of Windows around 1999 or 2000
had to check, but that like Linux, they don't really need to anymore.

cheers,
Len Brown, Intel Open Source Technology Center

