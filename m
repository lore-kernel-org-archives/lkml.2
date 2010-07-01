Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0GAToc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:44:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:60823 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab0GAToa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:44:30 -0400
From: Thomas Renninger <trenn@suse.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Provide /sys/../ec with read/write access and some cleanups
Date: Thu, 1 Jul 2010 21:44:26 +0200
User-Agent: KMail/1.9.10
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de
References: <1277996570-2686-1-git-send-email-trenn@suse.de> <20100701162239.GB4789@khazad-dum.debian.net>
In-Reply-To: <20100701162239.GB4789@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007012144.27477.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 July 2010 06:22:39 pm Henrique de Moraes Holschuh wrote:
> On Thu, 01 Jul 2010, Thomas Renninger wrote:
> > These patches are diffed against the test branch of the ACPI tree, but
> > also patch fine with 2.6.35-rc3.
> >
> > I thought about tainting the kernel if someone writes to the EC, but as
> > userspace can also write to graphics IO, PCI config or MSRs, it shouldn't
> > matter that much.
> > Eventually this should still be added (by a separate patch), one can
> > easily confuse the EC to not switch on the fans anymore.
> >
> > A small tool to read out and write to /sys/devices/system/ec/*/io can be
> > found here:
> > ftp://ftp.suse.com/pub/people/trenn/sources/ec/ec_access.c
> >
> > Len: Can you apply these into your test branch and schedule them for
> > linux-next and 2.6.36 if there are no objections, please.
>
> I am just wondering if we shouldn't have this in debugfs instead of regular
> /sys.  Do you envision *production* use of this facility, or should it just
> be something to use for debugging and hacking?
Only for debugging and hacking. Apps must not use it for production.
On the one hand I agree, on the other hand side  I think the EC somehow
fits into /sys/devices/system/ec. I don't have a strong opion on that, though.

      Thomas
