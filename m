Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab2A3PnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:43:04 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38219 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab2A3PnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:43:02 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.24.188]
In-Reply-To: <20120130144909.GT19255@amd.com>
References: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
 <1327603257-17028-3-git-send-email-joerg.roedel@amd.com> <CAK=WgbbZB0hGRr84JV4a7c0KvW7VbVzsnCx1PGg=wjoB0OSrYw@mail.gmail.com>
 <20120127102608.GK19255@amd.com> <CAK=WgbZQB+76FuJXK82x09CieDmF23zLQ8KbHbEtjnQsc_4axg@mail.gmail.com>
 <20120127130329.GM19255@amd.com> <CAK=WgbY+aBwTno4YxGLaxS7Y-R=CS1604+c5j-6EMQSfJeGvTA@mail.gmail.com>
 <20120130144909.GT19255@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 30 Jan 2012 17:42:42 +0200
Message-ID: <CAK=WgbYhymxGi4VHKcYe1Lq6KHC3Lp5zCOYGdD334GjmB-mmTQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 4:49 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> Hardware specific attributes are intended, but not limited to hardware
> specific drivers. A generic driver that _may_ run on a given hardware
> can use a hardware specific attribute too. If it doesn't run on this
> hardware it will just get -EINVAL back.

That sounds good.

But I'm still not sure what's the advantage of the attribute API on
top of regular, type-safe, dedicated API for every attribute: it
doesn't sound like there's a vast number of attributes, only a
handful, and dedicated API just sound (to me) much more readable and
less prone to error.

But, again, maybe it's only me :)

Thanks,
Ohad.
