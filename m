Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2KNCYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:24:21 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7991 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375Ab2KNCYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:24:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 13 Nov 2012 18:24:09 -0800
Message-ID: <50A300C1.1000501@nvidia.com>
Date: Wed, 14 Nov 2012 10:24:01 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Dave Airlie <airlied@redhat.com>, Rob Clark <robdclark@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] drm: Add NVIDIA Tegra20 support
References: <1352757358-14001-1-git-send-email-thierry.reding@avionic-design.de> <1352757358-14001-2-git-send-email-thierry.reding@avionic-design.de> <50A1F3A3.40905@nvidia.com> <50A28542.8020406@wwwdotorg.org>
In-Reply-To: <50A28542.8020406@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 01:37 AM, Stephen Warren wrote:
> On 11/13/2012 12:15 AM, Mark Zhang wrote:
>> On 11/13/2012 05:55 AM, Thierry Reding wrote:
>>> This commit adds a KMS driver for the Tegra20 SoC. This includes basic
>>> support for host1x and the two display controllers found on the Tegra20
>>> SoC. Each display controller can drive a separate RGB/LVDS output.
> 
> Mark, when you're replying to a long patch, it's useful to quote only
> the code you're directly responding to; slowly scrolling through your
> email to find your comments is rather error-prone and time-consuming.
>

Sure. Sorry for the inconvenience. Thanks.

> Thanks for the feedback though.
> 
