Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2BEKap (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 05:30:45 -0500
Received: from manchmal.in-ulm.de ([217.10.9.201]:57231 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab2BEKao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 05:30:44 -0500
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Feb 2012 05:30:44 EST
Date: Sun, 5 Feb 2012 11:20:48 +0100
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [0/1] 3.0.20-stable review
Message-ID: <1328434946@msgid.manchmal.in-ulm.de>
References: <20120203220745.GA3459@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203220745.GA3459@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote...

> Please let me know if anyone has any problems with it as soon as possible.

After two tests without any visible change in neither power
consumption nor system stability: How do I identify computers where
that patch _might_ change things? Does for example

    ACPI _OSC control for PCIe not granted, disabling ASPM

indicate that box isn't worth any efforts? Does this patch void a
"pcie_aspm=force" kernel parameter, should or even must that one be
given?

And another question, what are "any problems" likely to be? Obvious
things like crashes, or rather nasty things like slowly eating data on
the disks?

I bet there are some documents around about that, so pointers will do.
There's <Documentation/kernel-parameters.txt> and
<https://wiki.ubuntu.com/Kernel/PowerManagementASPM> but these don't
answer my questions.

> Responses should be made by Monday, February 6, 2012, 20:00:00 UTC.
> Anything received after that time might be too late.

Having said that, no appearent effect found on (DMI string from
dmesg):

- D945GCLF2, BIOS LF94510J.86A.0278.2010.0414.2000 04/14/2010
- M4A88T-V EVO, BIOS 0405 12/15/2010

    Christoph
