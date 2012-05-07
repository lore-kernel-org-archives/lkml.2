Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab2EGMpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 08:45:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58940 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab2EGMpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 08:45:31 -0400
MIME-Version: 1.0
In-Reply-To: <1335892455-10155-1-git-send-email-swarren@wwwdotorg.org>
References: <1335892455-10155-1-git-send-email-swarren@wwwdotorg.org>
Date: Mon, 7 May 2012 14:45:30 +0200
Message-ID: <CACRpkdbOjLoSgBfYH0gFH3d63UWp+fsygL4dm7=7c=0NKZhN1Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: add more info to error msgs in pin_request
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 7:14 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> Additionally print which pin the request failed for, which entity already
> claimed it, and what entity was trying to claim it.
>
> Remove duplicate device name from a debug message.
>
> Clean up some indentation.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Obviously fine, so applied.

Thanks,
Linus Walleij
