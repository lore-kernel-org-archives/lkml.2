Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab2F3Dkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 23:40:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10948 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2F3Dky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 23:40:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 29 Jun 2012 20:37:40 -0700
Message-ID: <4FEE77F3.6020600@nvidia.com>
Date: Sat, 30 Jun 2012 12:52:19 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: tegra: add Ventana backlight device
References: <1340976299-27601-1-git-send-email-acourbot@nvidia.com> <4FEDD28D.1000303@wwwdotorg.org>
In-Reply-To: <4FEDD28D.1000303@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 30 Jun 2012 01:06:37 AM JST, Stephen Warren wrote:
> As I mentioned downstream, I have a patch to add all the regulators for
> Ventana to DT. This patch should be rebased on top of that, since it
> adds the backlight regulator node too, but co-locates it with a bunch of
> other regulators, so won't merge with this patch.

Ok, better wait for your patch then. No need to hurry, this depends on 
other stuff anyway.

Alex.
