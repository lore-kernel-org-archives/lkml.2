Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2KSGTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:19:06 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3465 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2KSGTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:19:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 18 Nov 2012 22:18:56 -0800
Message-ID: <50A9CF4B.2040308@nvidia.com>
Date: Mon, 19 Nov 2012 14:18:51 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "airlied@redhat.com" <airlied@redhat.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] drm: Add NVIDIA Tegra30 support
References: <1353041889-3114-1-git-send-email-markz@nvidia.com> <50A66A02.6030608@wwwdotorg.org>
In-Reply-To: <50A66A02.6030608@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2012 12:29 AM, Stephen Warren wrote:
> On 11/15/2012 09:58 PM, Mark Zhang wrote:
>> This patch is based on Thierry's drm patch for Tegra20:
>> - [PATCH v2 0/6] Device tree updates for host1x support
>> - [PATCH v3 0/2] NVIDIA Tegra DRM driver
>>
>> It adds the support for NVIDIA Tegra30.
> 
> Mark, I tried to apply this for testing locally, but it doesn't apply.
> 
> For some reason, all the whitespace in the context has been replaced
> with spaces. Are your local copies of dc.c and host1x.c indented with
> spaces for some reason, or did the MS Exchange server corrupt your patch
> as you sent it (I've previously only observed inbound corruption...)
> 

I think that is because the whitespace in patch which Thierry sent:
"[PATCH v3 1/2] drm: Add NVIDIA Tegra20 support" are all spaces, not tabs.

P.S: I saved the patch mail into an eml file and use "git am <eml file>"
to integrate it into my local tree.
