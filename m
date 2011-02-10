Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab1BJVnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:43:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49474 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766Ab1BJVnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:43:10 -0500
Date: Thu, 10 Feb 2011 22:43:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Borislav Petkov <bp@amd64.org>, Greg KH <greg@kroah.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/30] amd64_edac: Add Bulldozer support
Message-ID: <20110210214304.GB19248@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Borislav Petkov <bp@amd64.org>, Greg KH <greg@kroah.com>,
	Ingo Molnar <mingo@elte.hu>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
 <20110210185637.GA16128@kroah.com>
 <20110210192034.GI12244@aftab>
 <20110210112249.255aa016@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110210112249.255aa016@jbarnes-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 11:22:49AM -0800, Jesse Barnes wrote:
> > Jesse, do you want the patch at
> > http://marc.info/?l=linux-edac&m=129735827731488&w=2 rerouted over your
> > tree or would you rather ack it?
> 
> You can have my ack:
> 
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Thanks.

> Though if that's the only place that PCI ID is used, you may as well
> just put it into the corresponding file and remove it from pci_ids.h
> altogether.

Yeah, this patchset adds another user of PCI_DEVICE_ID_AMD_15H_NB_F3 in
amd64_edac.c, this was the reasoning to move it to pci_ids.h

In contrast, I'm also introducing PCI_DEVICE_ID_AMD_15H_NB_F[12] which
are used only in this driver and thus I've left them in its header.
We'll move them to pci_ids.h only if some other user of them appears.

Thanks.

-- 
Regards/Gruss,
    Boris.
