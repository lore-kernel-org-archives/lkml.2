Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab1AMRKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:10:31 -0500
Received: from www.tglx.de ([62.245.132.106]:48860 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871Ab1AMRK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:10:29 -0500
Date: Thu, 13 Jan 2011 18:10:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg@redhat.com>
cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
In-Reply-To: <20110113164616.GB21289@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com> <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com> <20110113164616.GB21289@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Matthew Garrett wrote:

> On Thu, Jan 13, 2011 at 10:02:22AM -0600, Manoj Iyer wrote:
> > Set acpi_skip_timer_override to force ignoring BIOS
> > IRQ0 pin2 override. This fixes resume from suspend on
> > AMD based ThinkPad Edge 11,13,14 and 15.
> 
> This was originally there because of a quirk in some ati chipsets, 
> coupled with DSDT insanity on HP's part. The Thinkpad Edges seem to be 
> Intel machines, so it's not the same underlying issue. Do we have any 

The patch description above talks explictely about AMD based ThinkPad
Edge. So it might be as well the same underlying problem.

Thanks,

	tglx
