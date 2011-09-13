Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab1IMKUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:20:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48826 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1IMKUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:20:17 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.113.217]
In-Reply-To: <20110913100034.GJ11701@amd.com>
References: <1315421604-12286-1-git-send-email-ohad@wizery.com>
 <20110912160252.GE11701@amd.com> <CAK=WgbZCDsBk+dueKfAX3ewsvqEnVDN+jW_ftW+BDKnayunOwA@mail.gmail.com>
 <20110913100034.GJ11701@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 13 Sep 2011 13:19:56 +0300
Message-ID: <CAK=WgbZ0TGDevR+HP=KmE1DDanSwCxOnpNf_wn2UfRATALJHcw@mail.gmail.com>
Subject: Re: [PATCH 1/3] iommu/core: add fault reporting mechanism
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 1:00 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> For now I think it is the best to remove this IOMMU_ERROR thing. It is
> inherent to the function call already. When a real use-case comes up we
> can easily add it later.

I'm fine with this, will post an update.

Thanks,
Ohad.
