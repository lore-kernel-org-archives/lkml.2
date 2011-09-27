Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1I0LUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:20:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37058 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab1I0LUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:20:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=WgbY8dW113CbzUoBVbvGwYQSQJZ-qi03A1O9zwKYEr4RyBA@mail.gmail.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
	<1316792756-3395-9-git-send-email-joerg.roedel@amd.com>
	<CAK=WgbbZKa2orya_ijJ3vBeyERN2FYCKaSyn8gs=qsqJRC=kbQ@mail.gmail.com>
	<20110926122213.GC2138@amd.com>
	<CAK=WgbYvACc4U58WTxdndKtHgA0TxV-wFmO8bQLD65yuz_Hk0w@mail.gmail.com>
	<20110927110012.GJ2138@amd.com>
	<CAK=WgbY8dW113CbzUoBVbvGwYQSQJZ-qi03A1O9zwKYEr4RyBA@mail.gmail.com>
Date: Tue, 27 Sep 2011 20:20:03 +0900
X-Google-Sender-Auth: S2akF_WSjxxWMFZR7zXezBuP6Fk
Message-ID: <CAHQjnOOOdZmBVD1vRWC6x1aqtj97eGCO5Be7KRxB+Yv659sNwA@mail.gmail.com>
Subject: Re: [PATCH 08/10] iommu/omap: Use bus_set_iommu instead of register_iommu
From: KyongHo Cho <pullip.cho@samsung.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
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

On Tue, Sep 27, 2011 at 8:10 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Tue, Sep 27, 2011 at 2:00 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
>> The question is, of course, if the IOMMU on the platform device can
>> identify single devices on the bus that originates from it?
>
> We can probably query the ancestors of those devices until we find one
> with IOMMU properties.

We make a relationship between a platform device and
its dedicated IOMMU (Exynos System MMU) while machine initialization.
The information about the relationship is stored in the platdata of
IOMMU device descriptor
and it is also a platform device.

Exynos platform is in similar situation with OMAP's,
whereas implementation is different.
