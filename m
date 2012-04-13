Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2DMQBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:01:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40829 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab2DMQBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:01:12 -0400
Message-ID: <4F884DC3.70800@wwwdotorg.org>
Date: Fri, 13 Apr 2012 10:01:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: tegra: debugfs enhancements
References: <1334184439-16428-1-git-send-email-swarren@wwwdotorg.org> <CACRpkdYiWTNQ7hVM4NczyemxOcHWNcK639-yoh2iWc-5_WQB2Q@mail.gmail.com>
In-Reply-To: <CACRpkdYiWTNQ7hVM4NczyemxOcHWNcK639-yoh2iWc-5_WQB2Q@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 06:46 AM, Linus Walleij wrote:
> On Thu, Apr 12, 2012 at 12:47 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> * Only provide debugfs-relates ops when CONFIG_DEBUG_FS is enabled.
>> * Implement pin_config_group_dbg_show op.
>> * Implement pin_config_config_dbg_show op.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> Linus, this too would be best to take through the Tegra tree. It depends
>> on the other two patches I just posted, but to satisfy that, I'll just
>> base my branch off of pinctrl once you've applied those branches and its
>> stable.
> 
> OK that means you need that other patch adding the debug callback to
> be in some stable branch so you can pull it into the Tegra
> tree I guess?
> 
> Can we conclude base stabilization from this and say that the series
> of patches upto debugfs enhancements v2 (with the kerneldoc fix)
> is the stable merge base, and I'll push some tag for that.

Sounds good to me.

> And once that settles:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks.
