Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab2K0HeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:34:01 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56413 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab2K0HeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:34:00 -0500
MIME-Version: 1.0
In-Reply-To: <50B46336.8030605@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	<1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
	<CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>
	<50B46336.8030605@nvidia.com>
Date: Tue, 27 Nov 2012 17:33:59 +1000
Message-ID: <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Third would be having a firewall in 2D driver checking the stream and
> ensuring all registers that accept addresses are written by values
> derived from dmabufs. I haven't tried implementing this, but it'd
> involve a lookup table in kernel and CPU reading through the command
> stream. Offsets and sizes would also need to be validated. There would
> be a performance hit.

This is the standard mechanism, and what exynos does as well.

The per process VM method is also used as an extension to this on some hw.

Dave.
