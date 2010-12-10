Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0LJVSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:18:55 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41057 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0LJVSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:18:54 -0500
Date: Fri, 10 Dec 2010 21:18:49 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Disable ASPM if BIOS asks us to
Message-ID: <20101210211849.GA16597@srcf.ucam.org>
References: <1291662056-6055-1-git-send-email-mjg@redhat.com> <20101210130719.6ef6cd3d@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210130719.6ef6cd3d@jbarnes-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 01:07:19PM -0800, Jesse Barnes wrote:
> On Mon,  6 Dec 2010 14:00:56 -0500
> Matthew Garrett <mjg@redhat.com> wrote:
> 
> > We currently refuse to touch the ASPM registers if the BIOS tells us that
> > ASPM isn't supported. This can cause problems if the BIOS has (for any
> > reason) enabled ASPM on some devices anyway. Change the code such that we
> > explicitly clear ASPM if the FADT indicates that ASPM isn't supported,
> > and make sure we tidy up appropriately on device removal in order to deal
> > with the hotplug case. If ASPM is disabled because the BIOS doesn't hand
> > over control then we won't touch the registers.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > ---
> > 
> 
> Applied to linux-next, thanks.

Agh. It seems I sent the wrong version - there's a missing e in 
pci_clear_aspm. Can you fix that up, or should I resend?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
