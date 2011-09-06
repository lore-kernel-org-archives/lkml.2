Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1IFL3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 07:29:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45882 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab1IFL2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 07:28:54 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.113.217]
In-Reply-To: <20110906101535.GT16691@amd.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com> <20110906101535.GT16691@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 6 Sep 2011 14:28:32 +0300
Message-ID: <CAK=WgbZ=QqXgwvFzu8AGdXEMridoFri5sRb0gy9mKmT2WHZVxg@mail.gmail.com>
Subject: Re: [PATCH/RFC 0/7] iommu: fixes & extensions
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

On Tue, Sep 6, 2011 at 1:15 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> Ok, I applied 1-5 to their respective branches. Patch 6 needs some more
> discussion to make sure the interface is generally usable. Patch 7 seems
> to be a starting point for now. This definitly requires conversion of
> the other IOMMU drivers too.
> Please make individual patch-sets from patch 6 and 7 respectivly.

Will do, thanks !
