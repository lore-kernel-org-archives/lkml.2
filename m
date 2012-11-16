Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2KPQ37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:29:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59839 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2KPQ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:29:58 -0500
Message-ID: <50A66A02.6030608@wwwdotorg.org>
Date: Fri, 16 Nov 2012 09:29:54 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Zhang <markz@nvidia.com>
CC: airlied@redhat.com, thierry.reding@avionic-design.de,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] drm: Add NVIDIA Tegra30 support
References: <1353041889-3114-1-git-send-email-markz@nvidia.com>
In-Reply-To: <1353041889-3114-1-git-send-email-markz@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 09:58 PM, Mark Zhang wrote:
> This patch is based on Thierry's drm patch for Tegra20:
> - [PATCH v2 0/6] Device tree updates for host1x support
> - [PATCH v3 0/2] NVIDIA Tegra DRM driver
> 
> It adds the support for NVIDIA Tegra30.

Mark, I tried to apply this for testing locally, but it doesn't apply.

For some reason, all the whitespace in the context has been replaced
with spaces. Are your local copies of dc.c and host1x.c indented with
spaces for some reason, or did the MS Exchange server corrupt your patch
as you sent it (I've previously only observed inbound corruption...)
