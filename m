Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0LJVVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:21:13 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:44525 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751289Ab0LJVVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:21:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cX6JuO6jyIcnqKDQBbFgoycN4BuJ7oZP7MCMXQp5AEWSz0Rg3aSf85XOzmdakb6jDPU3/NlCRWL2mM7hEWN2Riubyc5AQRik7LVR8f+p4o9n7FxrkEDvd+o0mp8/gyMb;
Date: Fri, 10 Dec 2010 13:21:08 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Disable ASPM if BIOS asks us to
Message-ID: <20101210132108.180b5114@jbarnes-desktop>
In-Reply-To: <20101210211849.GA16597@srcf.ucam.org>
References: <1291662056-6055-1-git-send-email-mjg@redhat.com>
	<20101210130719.6ef6cd3d@jbarnes-desktop>
	<20101210211849.GA16597@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010 21:18:49 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Fri, Dec 10, 2010 at 01:07:19PM -0800, Jesse Barnes wrote:
> > On Mon,  6 Dec 2010 14:00:56 -0500
> > Matthew Garrett <mjg@redhat.com> wrote:
> > 
> > > We currently refuse to touch the ASPM registers if the BIOS tells us that
> > > ASPM isn't supported. This can cause problems if the BIOS has (for any
> > > reason) enabled ASPM on some devices anyway. Change the code such that we
> > > explicitly clear ASPM if the FADT indicates that ASPM isn't supported,
> > > and make sure we tidy up appropriately on device removal in order to deal
> > > with the hotplug case. If ASPM is disabled because the BIOS doesn't hand
> > > over control then we won't touch the registers.
> > > 
> > > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > > ---
> > > 
> > 
> > Applied to linux-next, thanks.
> 
> Agh. It seems I sent the wrong version - there's a missing e in 
> pci_clear_aspm. Can you fix that up, or should I resend?

I'll fix it up (was just doing the build test now), thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
