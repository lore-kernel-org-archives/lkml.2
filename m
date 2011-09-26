Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1IZWPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:15:43 -0400
Received: from 8bytes.org ([88.198.83.132]:53433 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab1IZWPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:15:41 -0400
Date: Tue, 27 Sep 2011 00:15:39 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] PCI: Add support for PASID capability
Message-ID: <20110926221539.GG15002@8bytes.org>
References: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com> <1316706551-16138-5-git-send-email-joerg.roedel@amd.com> <CAErSpo7Vb7avbsP3eG=3huCewW4QBL7oMoXr2TjMCaWEvFgB0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7Vb7avbsP3eG=3huCewW4QBL7oMoXr2TjMCaWEvFgB0Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 02:58:58PM -0600, Bjorn Helgaas wrote:
> On Thu, Sep 22, 2011 at 9:49 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> > Devices supporting the PASID capability can use multiple
> > contexts on an IOMMU at the same time. This patch adds
> > support to manage that capability.
> 
> These all look reasonable to me.
> 
> Is there anything else useful you could say in the PASID Kconfig help
> text?  I'm guessing it stands for "PCI Address Space ID" or something,
> but I have no idea why I might want to enable it.

PASID stands for Process Address Space ID, it basically allows a PCI
device to access multiple IO address spaces at the same time using an
IOMMU. Users should enable it when they want to compile an IOMMU driver
into the kernel that supports PASIDs for the translated devices.
I'll add all that information to the Kconfig help. Thanks a lot for your
feedback :)

> I didn't coordinate very well with Jesse.  I'm hoping he'll be back
> before the 3.2 merge window, but I think we have a few patches queued
> up now, and it might be useful to have them in linux-next for a while
> before he returns.  I'll look into that.

Great, thanks again.

Regards,

	Joerg

