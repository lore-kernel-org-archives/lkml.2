Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1IZM30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 08:29:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49646 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1IZM3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 08:29:25 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.133.94]
In-Reply-To: <20110926122213.GC2138@amd.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
 <1316792756-3395-9-git-send-email-joerg.roedel@amd.com> <CAK=WgbbZKa2orya_ijJ3vBeyERN2FYCKaSyn8gs=qsqJRC=kbQ@mail.gmail.com>
 <20110926122213.GC2138@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 26 Sep 2011 15:29:04 +0300
Message-ID: <CAK=WgbYvACc4U58WTxdndKtHgA0TxV-wFmO8bQLD65yuz_Hk0w@mail.gmail.com>
Subject: Re: [PATCH 08/10] iommu/omap: Use bus_set_iommu instead of register_iommu
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 3:22 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> That is interesting. What bus do these IOMMU users you talk about belong
> to?

E.g., virtio devices (which today originates from a platform device)
or even rpmsg users (which originates from the former virtio devices).

> Is it a seperate bus that originates from a platform device?

Yes.

> in that
> case the situation sounds a little bit like with USB on x86. The usb
> controlers are PCI devices and DMA handles are allocated using the
> pci_dev of the controler and not the usb_device.

Yeah, sounds very similar.

Thanks,
Ohad.
