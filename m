Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786Ab2IKRMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:12:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40080 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2IKRMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:12:25 -0400
Message-ID: <504F70F7.9020303@wwwdotorg.org>
Date: Tue, 11 Sep 2012 11:12:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: linux-tegra@vger.kernel.org
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: tegra: move pinconf-tegra.h content into drivers/pinctrl
References: <1346798370-28795-1-git-send-email-swarren@wwwdotorg.org> <CACRpkdaDQtHvtH-gqps5T5c=EZOzFkMVkg0QbOabzT1zQ1kBdQ@mail.gmail.com>
In-Reply-To: <CACRpkdaDQtHvtH-gqps5T5c=EZOzFkMVkg0QbOabzT1zQ1kBdQ@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 02:26 AM, Linus Walleij wrote:
> On Wed, Sep 5, 2012 at 12:39 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Now that Tegra's pinmux is configured solely from device tree, there's
>> no need for the pinconf types to be defined in arch/arm/mach-tegra/.
>> Move it into the pinctrl directory to clean up mach-tegra, as a pre-
>> requisite for single-zImage.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> I'll need to take this through the Tegra tree, since it depends on some
>> patches that remove inclusion of the deleted header.
> 
> Go for it:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Applied to Tegra's for-3.7/cleanup2 branch.

