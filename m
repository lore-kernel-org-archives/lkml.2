Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1JKRE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:04:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62792 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab1JKREX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:04:23 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.27.118]
In-Reply-To: <CAHQjnOPcetkp-XX0x4HQsR+iYN1SaCAhuBEE2nVTdhssFpUmJQ@mail.gmail.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
 <1316195506-9777-2-git-send-email-ohad@wizery.com> <20110927100505.GH2138@amd.com>
 <CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com>
 <20110927131222.GL2138@amd.com> <CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
 <20110927181438.GM2138@amd.com> <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
 <20111010094738.GW2138@amd.com> <CAK=WgbZ7Wyax1yfS1jSXw9OdwMtxxidwLO8PTsNUXX9CWzmVrw@mail.gmail.com>
 <20111010153609.GB2138@amd.com> <CAK=WgbbnuO67X46sqS87q2vw2TWq3Ekvw5p1PmXvXinQXMyowg@mail.gmail.com>
 <CAHQjnOPcetkp-XX0x4HQsR+iYN1SaCAhuBEE2nVTdhssFpUmJQ@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 11 Oct 2011 19:04:01 +0200
Message-ID: <CAK=WgbZeZhr1AN82e1yab-rLWyB0tuK-s3wM+YoeJ24rsoXk2Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On Tue, Oct 11, 2011 at 4:59 PM, KyongHo Cho <pullip.cho@samsung.com> wrote:
> I think the type of size should be size_t.
..
> Thus, it should be
> iommu_unmap(domain, orig_iova, orig_size - size)

Agree with both suggestions, thanks !

P.S - please only keep the parts of my email which you are replying
to, otherwise it's a bit hard to find your comments.

Thanks,
Ohad.
