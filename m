Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1DDNLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:11:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab1DDNLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:11:00 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: sfr@canb.auug.org.au
Subject: [SUBMIT REQUEST] cpupowerutils for linux-next
Date: Mon, 4 Apr 2011 15:10:56 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.1-1.2-desktop; KDE/4.6.0; x86_64; ; )
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Len Brown <lenb@kernel.org>, "Greg Kroah-Hartman" <gregkh@novell.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104041510.56570.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is about the recently announced cpupowerutils project
based on or say an enhancement of the well know
cpufrequtils project:
http://www.spinics.net/lists/cpufreq/msg02137.html

It's basically cpufrequtils with some cpuidle info additions
and the Intel only turbostat tool merged into it in a way
that it can easily get extended for other HW (and got extended
with some AMD facilities).

As there is tools/power/x86 for some time, it would be very
convenient to get cpupowerutils merged into linux-next (for now)
into the tools/power/cpupower directory:
Most of it is directly based on the cpufreq/cpuidle kernel
subsystem and the output gathered by it should be attached
to any CPU frequency/idle related kernel bug.

Dominik was so kind to add the stuff to his pcmcia git tree
as cpupowerutils branch.
Therefore, this can easily be added by pulling from:
git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git cpupowerutils

Even the MAINTAINERS file got adjusted already (thanks!):
CPU POWER MONITORING SUBSYSTEM
M:      Dominik Brodowski <linux@dominikbrodowski.net>
M:      Thomas Renninger <trenn@suse.de>
S:      Maintained
F:      tools/power/cpupower


Stephen: I added lkml, linux-pm lists and kernel people I know
working in this area. Please tell me if you can/will just
pull this or whatever you need to make it happen.

Thanks,

     Thomas
