Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab2L0AvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 19:51:07 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:56602 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2L0AvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 19:51:05 -0500
MIME-Version: 1.0
In-Reply-To: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Dec 2012 17:50:42 -0700
Message-ID: <CAErSpo6QWZfZ9YQAXkDOPvqBrwhS4wEzrxiUSAi7myVfoDGaKA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Thunderbolt workarounds
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 12:25 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> I had chance to test two PC setups with Thunderbolt: Acer Aspire S5 and
> Intel DZ77RE-75K motherboard. Unfortunately, both of them are broken in
> different ways.
>
> This patchset contains workarounds for the issues.
>
> Kirill A. Shutemov (3):
>   PCI Hotplug: workaround for Thunderbolt on Acer Aspire S5
>   PCI Hotplug: convert acpiphp_hp_work to use delayed work
>   PCI Hotplug: workaround for Thunderbolt on Intel DZ77RE-75K
>     motherboard
>
>  drivers/pci/hotplug/acpi_pcihp.c   |   13 +++++++++++++
>  drivers/pci/hotplug/acpiphp_glue.c |   33 +++++++++++++++++++++++++--------
>  2 files changed, 38 insertions(+), 8 deletions(-)

I'm ignoring these for now.  [1/3] has a hardcoded BIOS path that I
don't think is the right approach and [3/3] has a timeout issue to be
addressed.  [2/3] might be worthwhile by itself, but I'd rather merge
a complete solution when it's ready.

Bjorn
