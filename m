Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab2LAROA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 12:14:00 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1794 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2LARN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 12:13:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 01 Dec 2012 09:13:33 -0800
Message-ID: <50BA3ACD.9080104@nvidia.com>
Date: Sat, 1 Dec 2012 19:13:49 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com> <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de> <50B874C7.5030208@nvidia.com> <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de> <50B9EA76.10803@nvidia.com> <20121201145814.GB18209@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121201145814.GB18209@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.2012 16:58, Thierry Reding wrote:
> I don't know where you see politics in what I said. All I'm saying is
> that we shouldn't be making things needlessly complex. In my experience
> the technically cleanest solution is usually the one with the least
> complexity.

Let me come up with a proposal and let's then see where to go next.

> But you already have extra code in the kernel to patch out expired sync-
> points. Is it really worth the added effort to burden userspace with
> this? If so I still think some kind of generic IOCTL to retrieve
> information about a syncpoint would be better than a sysfs interface.

That's exactly why I mentioned that it's not useful to upstream. There
are some cases where user space might want to check if a fence has
passed without waiting for it, but that's marginal and could be handled
even with waits with zero timeout.

Terje
