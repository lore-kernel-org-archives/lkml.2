Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423292Ab2KNUP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:15:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46052 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2KNUP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:15:58 -0500
Message-ID: <50A3FBFA.3080008@wwwdotorg.org>
Date: Wed, 14 Nov 2012 13:15:54 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de> <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de> <50A357D3.9080002@nvidia.com> <20121114084931.GA31837@avionic-0098.mockup.avionic-design.de> <50A3712E.7000104@nvidia.com> <20121114105406.GA31455@avionic-0098.mockup.avionic-design.de> <50A3C485.7080704@wwwdotorg.org> <20121114200415.GA10335@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121114200415.GA10335@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 01:04 PM, Thierry Reding wrote:
...
> According to tegra20_clocks_data.c, the maximum clock frequency
> for host1x is 166 MHz, so 216 is probably not a good idea. 150 MHz
> sounds sensible, though.

As a general rule, I wouldn't rely on the upstream clock driver to
specify accurate maximum clock rates at the moment. Our downstream
kernel is more likely to be accurate. Still, upstream might be correct
here already...
