Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab1KUTyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:54:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36096 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1KUTyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:54:16 -0500
MIME-Version: 1.0
In-Reply-To: <1321898245-5231-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1321898245-5231-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Mon, 21 Nov 2011 20:54:15 +0100
Message-ID: <CACRpkdanErOt+Gi4mVxLm6sJSZSQTXtxkbvteMAyJu8sQ3QqsA@mail.gmail.com>
Subject: Re: [PATCH] gpio: pca953x: Staticise pca953x_get_altdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, David Jander <david@protonic.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 6:57 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> It's not used outside of the driver so doesn't need to be exported, and
> sparse notices this and complains about it.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

OK I've queued this for the -rcs.

Thanks!
Linus Walleij
