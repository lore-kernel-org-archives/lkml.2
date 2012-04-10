Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091Ab2DJPzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:55:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44726 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab2DJPzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:55:39 -0400
Message-ID: <4F8457F9.7090309@wwwdotorg.org>
Date: Tue, 10 Apr 2012 09:55:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 REPOST 5/5] pinctrl: tegra: Add complete device tree
 support
References: <1333553270-9040-1-git-send-email-swarren@wwwdotorg.org>	<1333553270-9040-5-git-send-email-swarren@wwwdotorg.org> <CACRpkdZzET9OKC8xoXV_4OBAd9-EuhSh-OfG=es56bKidCoe9Q@mail.gmail.com>
In-Reply-To: <CACRpkdZzET9OKC8xoXV_4OBAd9-EuhSh-OfG=es56bKidCoe9Q@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 02:25 AM, Linus Walleij wrote:
> On Wed, Apr 4, 2012 at 5:27 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Implement pinctrl_ops dt_node_to_map() and dt_free_map(). These allow
>> complete specification of the desired pinmux configuration using device
>> tree.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
>> ---
>> v3: Rebase on of_property_for_each_string() API changes.
>>    Improve DT parsing so it only calls krealloc() on the top-level map
>>    table once per subnode, rather than once per subnode/pin combination.
>> v2: Rebase on of_property_for_each_string() API changes.
> 
> Applied to pinctrl, thanks!
> Linus Walleij

Great.

Is your pinctrl for-next branch considered "stable" (i.e. it won't ever
be rebased) at least up to commit a57be23 "pinctrl: tegra: Add complete
device tree support"?

If so, I'll use it as a base for the Tegra GPIO and pinmux rework branch.

Thanks.
