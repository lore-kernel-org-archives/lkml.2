Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab2LDGNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 01:13:38 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19998 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2LDGNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 01:13:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 03 Dec 2012 22:12:36 -0800
Message-ID: <50BD9573.2080802@nvidia.com>
Date: Tue, 4 Dec 2012 08:17:23 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com> <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de> <50B874C7.5030208@nvidia.com> <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de> <50BCFB7E.4020007@wwwdotorg.org> <20121203210328.GA20884@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121203210328.GA20884@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.12.2012 23:03, Thierry Reding wrote:
> What's really difficult to follow is if an ops structure is accessed via
> some global macro. It also breaks encapsulation because you have a
> global ops structure. That may even work fine for now, but it will break
> once you have more than a single host1x in a system. I know this will
> never happen, but all of a sudden it happens anyway and the code breaks.
> Doing this right isn't very hard and it will lead to a better design and
> is less likely to break at some point.

I agree that the chip ops access goes through too much indirection and
macro magic (which I already declared I hate), so we're going to design
something simpler.

Terje
