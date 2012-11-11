Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2KKJkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 04:40:20 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59980 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2KKJkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 04:40:18 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.250.186]
In-Reply-To: <20121102192221.4253.34303.stgit@muffinssi.local>
References: <20121102192221.4253.34303.stgit@muffinssi.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 11 Nov 2012 11:39:57 +0200
Message-ID: <CAK=WgbYR8UMyDjySJLRC0tEbJO3FaFgjWxceNwMyVdMgEgwPig@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] Move rest of omap-iommu to live in drivers/iommu
To: Tony Lindgren <tony@atomide.com>, Joerg Roedel <joro@8bytes.org>,
        Omar Ramirez Luna <omar.luna@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 9:23 PM, Tony Lindgren <tony@atomide.com> wrote:
> We need to move the iommu code to live under drivers
> for arm common zImage support.

For the iommu changes in the entire series:

Acked-by: Ohad Ben-Cohen <ohad@wizery.com>

Joerg, it might relieve some pain if this will go through Tony's tree,
as there are some OMAP platform iommu changes coming in from Omar as
well (part of which might have already been merged in the omap
branches). Hope it's ok with both of you guys?

Omar, do you still have any iommu changes coming in ? Can we get
everything merged to the same tree ?

Thanks!
Ohad.
