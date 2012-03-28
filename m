Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab2C1O0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:26:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64206 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab2C1O0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:26:54 -0400
Message-ID: <4F731FAA.5040708@gmail.com>
Date: Wed, 28 Mar 2012 09:26:50 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL 0/5] Second batch of arm-soc changes
References: <1332918842-13521-1-git-send-email-olof@lixom.net>
In-Reply-To: <1332918842-13521-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 02:13 AM, Olof Johansson wrote:
> Hi Linus,
> 
> Here is the second batch of arm-soc changes for this merge window. As Arnd
> mentioned with the first cover letter, most of these either had external
> dependencies that have now been pulled in, or just needed a bit more
> linux-next bake time due to getting picked up close to the 3.3 release.
> 
> 
> There are 128 non-merge patches, with a total diffstat of:
> 
>  346 files changed, 10790 insertions(+), 2792 deletions(-)
> 
> So, while there's been some good cleanups especially in the first branch,
> there's been a net addition of code:
> 
> * New SoC family support for Samsung EXYNOS5250: clock tables, driver
>   updates, etc means net gain in code.
> * Added device tree conversions. Once we start to sunset non-device tree
>   boards on the enabled platforms, we should see payback in code removal.
> * Common clock framework. As SoCs get converted over to the framework,
>   we should see more code removal from this as well.
> 
> 
> There are a handful of merge conflicts on the branches, nothing that
> should be too messy to sort out. I've described each conflict in the
> corresponding pull request, including how we've resolved them in our
> for-next branch.
> 

Why isn't lakml getting copied on emails 1-5? The same thing happened
with Arnd's pull request. Are they getting hung up for moderator approval?

Rob
