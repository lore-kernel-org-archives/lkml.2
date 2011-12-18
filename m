Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1LRW1M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 17:27:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50278 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1LRW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 17:27:10 -0500
MIME-Version: 1.0
In-Reply-To: <1323993437-15149-2-git-send-email-swarren@nvidia.com>
References: <1323993437-15149-1-git-send-email-swarren@nvidia.com>
	<1323993437-15149-2-git-send-email-swarren@nvidia.com>
Date: Sun, 18 Dec 2011 23:27:10 +0100
Message-ID: <CACRpkdaKWcCReO27O6VjQNBCnSDu_tMLPLCkqR0aroUf7gLEVw@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: Pass name instead of device to pin_config_*
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 12:57 AM, Stephen Warren <swarren@nvidia.com> wrote:

> Obtaining a "struct pinctrl_dev *" is difficult for code not directly
> related to the pinctrl subsystem. However, the device name of the pinctrl
> device is fairly well known. So, modify pin_config_*() to take the device
> name instead of the "struct pinctrl_dev *".
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Thanks Stephen, excellent, both applied.

I had to fix it up a bit to match the other
refactoring patch I made so check the result in my tree or -next.

Linus
