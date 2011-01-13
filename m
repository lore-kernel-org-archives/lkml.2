Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab1AMRWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:22:16 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40946 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab1AMRWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:22:15 -0500
Date: Thu, 13 Jan 2011 18:22:05 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg@redhat.com>, Manoj Iyer <manoj.iyer@canonical.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Message-ID: <20110113172205.GA30866@kryptos.osrc.amd.com>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com>
 <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com>
 <20110113164616.GB21289@srcf.ucam.org>
 <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 06:10:01PM +0100, Thomas Gleixner wrote:
> On Thu, 13 Jan 2011, Matthew Garrett wrote:
> 
> > On Thu, Jan 13, 2011 at 10:02:22AM -0600, Manoj Iyer wrote:
> > > Set acpi_skip_timer_override to force ignoring BIOS
> > > IRQ0 pin2 override. This fixes resume from suspend on
> > > AMD based ThinkPad Edge 11,13,14 and 15.
> > 
> > This was originally there because of a quirk in some ati chipsets, 
> > coupled with DSDT insanity on HP's part. The Thinkpad Edges seem to be 
> > Intel machines, so it's not the same underlying issue. Do we have any 
> 
> The patch description above talks explictely about AMD based ThinkPad
> Edge. So it might be as well the same underlying problem.

Hmm, that's strange, I have an Edge 13 machine here, although not the
exact same model as the ones listed in the patch, mine is:

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: LENOVO
        Product Name: 01972NG
        Version: ThinkPad Edge 13"IAL#

and it suspends/resumes just fine.

Manoj, can you send us dmesg and lspci -vv outputs, please?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
