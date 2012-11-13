Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2KMRhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:37:12 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39445 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2KMRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:37:10 -0500
Message-ID: <50A28542.8020406@wwwdotorg.org>
Date: Tue, 13 Nov 2012 10:37:06 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mark Zhang <markz@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Dave Airlie <airlied@redhat.com>, Rob Clark <robdclark@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] drm: Add NVIDIA Tegra20 support
References: <1352757358-14001-1-git-send-email-thierry.reding@avionic-design.de> <1352757358-14001-2-git-send-email-thierry.reding@avionic-design.de> <50A1F3A3.40905@nvidia.com>
In-Reply-To: <50A1F3A3.40905@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 12:15 AM, Mark Zhang wrote:
> On 11/13/2012 05:55 AM, Thierry Reding wrote:
>> This commit adds a KMS driver for the Tegra20 SoC. This includes basic
>> support for host1x and the two display controllers found on the Tegra20
>> SoC. Each display controller can drive a separate RGB/LVDS output.

Mark, when you're replying to a long patch, it's useful to quote only
the code you're directly responding to; slowly scrolling through your
email to find your comments is rather error-prone and time-consuming.

Thanks for the feedback though.
