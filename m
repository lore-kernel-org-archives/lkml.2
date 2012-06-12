Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab2FLCzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:55:47 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65229 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124Ab2FLCzp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:55:45 -0400
MIME-Version: 1.0
In-Reply-To: <1339429021.24037.8.camel@bling.home>
References: <20120530201424.31527.33142.stgit@bling.home> <20120606110514.GG757@amd.com>
 <1339429021.24037.8.camel@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 11 Jun 2012 19:55:24 -0700
Message-ID: <CAErSpo6oaGBL7uG4ys7cp=qNP6KK3xgi-_MkmvDULmfpk-+-wA@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] IOMMU: Groups support
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, david@gibson.dropbear.id.au,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, gregkh@linuxfoundation.org,
        ddutile@redhat.com, liuj97@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 8:37 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Wed, 2012-06-06 at 13:05 +0200, Joerg Roedel wrote:
>> On Wed, May 30, 2012 at 02:18:29PM -0600, Alex Williamson wrote:
>> > v2:
>> >  - Trickle down changes from pci_get_dma_source() to better handle
>> >    PCI device reference counting in IOMMU driver patches
>>
>> Okay, I looked again over the code and looks good for merging to me.
>
> Great, thanks Joerg!
>
>>  The
>> IOMMU Groups code depends on changes in the PCI code. We need to work
>> out how to merge this.
>>
>> Bjorn,
>>
>> I need the PCI changes before I can merge the IOMMU Groups code. There
>> are two ways that would work for me:
>>
>>       a) You Ack the PCI patch-set from Alex and I put it into my tree
>>          and merge the IOMMU Group code on-top, or
>>       b) You merge the PCI related patch-set into a seperate branch
>>          which you can merge into your next-branch and which I can
>>          pull in to merge IOMMU Groups on-top.
>>
>> Please let me know what works best for you.

Joerg, I put the PCI changes into my "next" branch
(http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=shortlog;h=refs/heads/next).
 My feeble excuse is that I was on vacation last week, but that's
pretty lame because this has been hanging for much longer than that.

Bjorn
