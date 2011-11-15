Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab1KOKp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:45:56 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34320 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab1KOKpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:45:54 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.61.145]
In-Reply-To: <20111115103926.GA5627@amd.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com> <20111115103926.GA5627@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 15 Nov 2011 12:45:33 +0200
Message-ID: <CAK=WgbZ=0HctjLREv1oXEa=5ryY7C_6srO1Nt5uMowH+FyaHJQ@mail.gmail.com>
Subject: Re: [RFC 0/5] OMAP groundwork for IOMMU-based DMA API
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Tue, Nov 15, 2011 at 12:39 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> It doesn't apply cleanly, can you please rebase the code, collect the
> Acked-by's and resend?

Sure. I planned on resending after the "hardware pgsize" patches are
merged, but please tell me if you prefer it the other way around.

Thanks,
Ohad.
