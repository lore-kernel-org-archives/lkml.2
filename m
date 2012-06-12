Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2FLP4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:56:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54780 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2FLP4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:56:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120612062000.GA6932@8bytes.org>
References: <20120611152021.25959.71601.stgit@bling.home> <CAErSpo434tDtnSOxB_REG2jFNrZL=aZERWTmmK-cdjqM4z6yWg@mail.gmail.com>
 <20120612062000.GA6932@8bytes.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Jun 2012 09:55:59 -0600
Message-ID: <CAErSpo6J61+XhtEeXdE-5Evhs-SJ4=3iEZDAXGuRi9moAU8KhQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] PCI: Prep for VFIO and IOMMU Groups
To: Joerg Roedel <joro@8bytes.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, benh@kernel.crashing.org,
        aik@ozlabs.ru, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        david@gibson.dropbear.id.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 12:20 AM, Joerg Roedel <joro@8bytes.org> wrote:
> Hi Bjorn,
>
> On Mon, Jun 11, 2012 at 06:59:25PM -0600, Bjorn Helgaas wrote:
>> On Mon, Jun 11, 2012 at 8:26 AM, Alex Williamson
>> <alex.williamson@redhat.com> wrote:
>> > v3:
>> >  - Small change to device specific ACS check to allow quirk to
>> >   support yes/no/pass type functionality. (no change to other
>> >   patches and no trickle down through IOMMU series)
>> >
>> > Bjorn, what's needed to get these in?  Thanks,
>>
>> Sorry for the delay.  I applied these to my "next" branch (headed for
>> 3.6).  I didn't feel comfortable pushing them towards 3.5 since
>> they're not bugfixes, and they haven't been in -next yet.
>
> Great. Do you applied them directly to your next branch or do you have
> them in a seperate branch I can pull in to merge the IOMMU Groups
> patches on-top? The later would be really good :)

Hi Joerg, I have Alex's patches on a separate topic branch.  I folded
in the pci_get_dev() fix and pushed it to here:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git
topic/alex-vfio-prep

This is also included in my "next" branch.

Bjorn
