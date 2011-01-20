Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1ATRKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:10:47 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40375 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1ATRKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:10:46 -0500
Date: Thu, 20 Jan 2011 18:02:38 +0100
From: Anisse Astier <anisse@astier.eu>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pascal VITOUX <pascal@substantiel.fr>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH RFC] dmi-scan: Use little-endian for the first 3 fields
 of the UUID.
Message-ID: <20110120180238.36b8e335@destiny.ordissimo>
In-Reply-To: <201101191201.03971.bjorn.helgaas@hp.com>
References: <20110119185411.49668f81@destiny.ordissimo>
	<201101191201.03971.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Bjorn,

On Wed, 19 Jan 2011 12:01:02 -0700, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote :

> On Wednesday, January 19, 2011 10:54:11 am Anisse Astier wrote:
> > 
> > From: Pascal VITOUX <pascal@substantiel.fr>
> > 
> >  - Get SMBIOS version.
> >  - Byte-swap the first 3 fields of the UUID (DMI type 1) as off SMBIOS
> >    version 2.6.
> > 
> > This patch is an adaptation of Jean Delvare patches for dmidecode
> > rev1.100, rev1.01 and rev1.119.
> > http://cvs.savannah.gnu.org/viewvc/dmidecode/dmidecode.c?root=dmidecode&view=log
> > 
> > It is intended to get the same uuid from dmidecode tool as from sysfs kernel
> > tree, more compliant with SMBIOS specification.
> > Therefore this patch will have the kernel return a different UUID if you
> > are using a recent BIOS implementing SMBIOS >= 2.6.
> 
> It seems like a good idea to have /sys/class/dmi/id/product_uuid
> match what dmidecode reports.  Does dmidecode use the same algorithm
> (testing dmi_ver against 0x0206)?
Yes, it does.

> 
> It'd be nice to mention that /sys/... filename explicitly in the
> changelog, and maybe even include an example from a system where
> they previously did not match, and now do.
Indeed.

> 
> I don't have an opinion on the SMBIOS version stuff, but that looks
> like it should be split into a separate patch.
It seems it's wrong anyway and will need more patch splitting (see Jean
Delvare's email).

Thanks for the review,

Anisse

