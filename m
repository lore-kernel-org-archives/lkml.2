Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031442Ab2CFWb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:31:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33979 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030811Ab2CFWb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:31:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.41.161 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1331061132-25853-1-git-send-email-swarren@nvidia.com>
References: <1331061132-25853-1-git-send-email-swarren@nvidia.com>
Date: Tue, 6 Mar 2012 23:31:26 +0100
Message-ID: <CACRpkdbozBL9kJG_EQW8G7U-He+Lvf5kLetEu65FjLYX8hYR2A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Declare struct device
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 8:12 PM, Stephen Warren <swarren@nvidia.com> wrote:

> From: Stephen Warren <swarren@wwwdotorg.org>
>
> Add a dummy declaration of struct device to avoid the following warning:

Applied, thanks!
Linus Walleij
