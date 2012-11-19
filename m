Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab2KSHR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 02:17:29 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16175 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2KSHR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 02:17:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 18 Nov 2012 23:17:19 -0800
Message-ID: <50A9DCFC.3050005@nvidia.com>
Date: Mon, 19 Nov 2012 15:17:16 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] drm: Add NVIDIA Tegra30 support
References: <1353041889-3114-1-git-send-email-markz@nvidia.com> <50A66A02.6030608@wwwdotorg.org> <50A9CF4B.2040308@nvidia.com> <20121119064543.GB21890@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121119064543.GB21890@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 02:45 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Mon, Nov 19, 2012 at 02:18:51PM +0800, Mark Zhang wrote:
>> On 11/17/2012 12:29 AM, Stephen Warren wrote:
>>> On 11/15/2012 09:58 PM, Mark Zhang wrote:
>>>> This patch is based on Thierry's drm patch for Tegra20:
>>>> - [PATCH v2 0/6] Device tree updates for host1x support
>>>> - [PATCH v3 0/2] NVIDIA Tegra DRM driver
>>>>
>>>> It adds the support for NVIDIA Tegra30.
>>>
>>> Mark, I tried to apply this for testing locally, but it doesn't apply.
>>>
>>> For some reason, all the whitespace in the context has been replaced
>>> with spaces. Are your local copies of dc.c and host1x.c indented with
>>> spaces for some reason, or did the MS Exchange server corrupt your patch
>>> as you sent it (I've previously only observed inbound corruption...)
>>>
>>
>> I think that is because the whitespace in patch which Thierry sent:
>> "[PATCH v3 1/2] drm: Add NVIDIA Tegra20 support" are all spaces, not tabs.
> 
> I'm pretty sure the issue must be inbound corruption caused by you email
> setup. The patches I've sent use tabs properly and I've never seen my
> setup corrupt emails.
> 

Sorry Thierry. It's my bad. I tried to apply Alex's patch and found it
has the same issue, the whitespace is filled with spaces...

I also found if the patch is for dts files, the whitespaces are tabs.
That is really weird.

> It seems like this is not the first time that this happens for you guys
> and I think I remember it to be the reason why Stephen switched to using
> his private email address for open-source work. Your IT guys should fix
> this, really. It can't be that hard.
> 
> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
> 
