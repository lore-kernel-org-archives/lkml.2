Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab2F0JVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:21:48 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40364 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab2F0JVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:21:47 -0400
MIME-Version: 1.0
In-Reply-To: <1339465514-10766-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1339465514-10766-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Wed, 27 Jun 2012 10:21:46 +0100
Message-ID: <CAPM=9txnD5zoFrUya3dn4x6RnSsP4xyg+YLJvXr42K8T5EkY6w@mail.gmail.com>
Subject: Re: [PATCH] drm/i2c/ch7006: Convert to dev_pm_ops
From: Dave Airlie <airlied@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 2:45 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> The I2C specific suspend and resume functions have been deprecated and
> printing a warning on boot for over a year, dev_pm_ops should be used
> instead so convert to that.
>
> Also remove the suspend function since all it does is log.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Francisco Jerez <currojerez@riseup.net>

Thanks for this and I like the fact its been posted 5 times but never
compiled once.

Can you at least test compile it?

comment below:

>
> -}
> +       struct i2c_client *client = to_i2c_device(dev);

This isn't a function ^^

Dave.
