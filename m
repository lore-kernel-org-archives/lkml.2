Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2LAQWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 11:22:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1969 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab2LAQWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 11:22:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 01 Dec 2012 08:21:34 -0800
Message-ID: <50BA2EA8.4030000@nvidia.com>
Date: Sat, 1 Dec 2012 18:22:00 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com> <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de> <50B874C7.5030208@nvidia.com> <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de> <50B9EA76.10803@nvidia.com> <CAKMK7uGnm7M5ad=aeCNiFLYXbJZ9Nx-vsGrstjt5_3BcrqWVqA@mail.gmail.com>
In-Reply-To: <CAKMK7uGnm7M5ad=aeCNiFLYXbJZ9Nx-vsGrstjt5_3BcrqWVqA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.2012 15:42, Daniel Vetter wrote:
> Out of sheer curiosity: What are you using the coverage data of these
> register definitions for? When I looked into coverage analysis the
> resulting data seemed rather useless to me, since the important thing
> is how well we cover the entire dynamic state space of the hw+sw (e.g.
> crap left behind by the bios ...) and coverage seemed to be a poor
> proxy for that. Hence why I wonder what you're doing with this data

Yes, it's a poor proxy. But still, I use it to determine how big
portions of hardware address space and fields I'm touching when running
host1x tests. It's interesting data for planning tests, but not much more.

Best regards,
Terje

