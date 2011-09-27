Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab1I0LK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:10:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58179 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab1I0LK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:10:27 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.46.211]
In-Reply-To: <20110927110012.GJ2138@amd.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
 <1316792756-3395-9-git-send-email-joerg.roedel@amd.com> <CAK=WgbbZKa2orya_ijJ3vBeyERN2FYCKaSyn8gs=qsqJRC=kbQ@mail.gmail.com>
 <20110926122213.GC2138@amd.com> <CAK=WgbYvACc4U58WTxdndKtHgA0TxV-wFmO8bQLD65yuz_Hk0w@mail.gmail.com>
 <20110927110012.GJ2138@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 27 Sep 2011 14:10:06 +0300
Message-ID: <CAK=WgbY8dW113CbzUoBVbvGwYQSQJZ-qi03A1O9zwKYEr4RyBA@mail.gmail.com>
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

On Tue, Sep 27, 2011 at 2:00 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> The question is, of course, if the IOMMU on the platform device can
> identify single devices on the bus that originates from it?

We can probably query the ancestors of those devices until we find one
with IOMMU properties.
