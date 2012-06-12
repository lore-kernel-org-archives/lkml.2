Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab2FLA7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:59:50 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48304 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884Ab2FLA7s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:59:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120611152021.25959.71601.stgit@bling.home>
References: <20120611152021.25959.71601.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 11 Jun 2012 18:59:25 -0600
Message-ID: <CAErSpo434tDtnSOxB_REG2jFNrZL=aZERWTmmK-cdjqM4z6yWg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] PCI: Prep for VFIO and IOMMU Groups
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, benh@kernel.crashing.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, joerg.roedel@amd.com, dwmw2@infradead.org,
        konrad.wilk@oracle.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 8:26 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> v3:
>  - Small change to device specific ACS check to allow quirk to
>   support yes/no/pass type functionality. (no change to other
>   patches and no trickle down through IOMMU series)
>
> Bjorn, what's needed to get these in?  Thanks,

Sorry for the delay.  I applied these to my "next" branch (headed for
3.6).  I didn't feel comfortable pushing them towards 3.5 since
they're not bugfixes, and they haven't been in -next yet.

Bjorn
