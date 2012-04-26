Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2DZJco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:32:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35015 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab2DZJcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:32:42 -0400
MIME-Version: 1.0
In-Reply-To: <4F983D09.7040905@openwrt.org>
References: <1335371657-24120-1-git-send-email-swarren@wwwdotorg.org>
	<4F983D09.7040905@openwrt.org>
Date: Thu, 26 Apr 2012 11:02:37 +0200
Message-ID: <CACRpkdYV=X1QE0434SN+Wt6n=yRSA6nhnJaBkJqgPYe3iGdA5Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: add error messages to pinmux_map_to_setting()
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 8:06 PM, John Crispin <blogic@openwrt.org> wrote:
> On 25/04/12 18:34, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> pinmux_map_to_setting() detects a number of errors, but doesn't report
>> any specifics to the user, making debugging those errors hard.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> John, Linus,
>>
>> This is mostly just FYI in case John wants to roll this into his error
>> reporting patch - it's all the changes I made to any non-Tegra files when
>> debugging my DT map data.
>>
>>  drivers/pinctrl/pinmux.c |   38 ++++++++++++++++++++++++++++----------
>>  1 files changed, 28 insertions(+), 10 deletions(-)
> Hi Stephen,
>
> I was just about to send my patch. However, I will first fold your
> suggestions into it.

OK so I don't apply this and wait for the final patch from John.

Yours,
Linus Walleij
