Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab2GENbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:31:23 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54954 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab2GENbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:31:22 -0400
MIME-Version: 1.0
In-Reply-To: <1341414405-6401-1-git-send-email-ldewangan@nvidia.com>
References: <1341414405-6401-1-git-send-email-ldewangan@nvidia.com>
Date: Thu, 5 Jul 2012 15:31:21 +0200
Message-ID: <CACRpkdbaNt=KX0s7vGrDzM7wKps3KFd1aF5B_S+E-LCt=XQ4DQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: tps65910: initialize of_node of gpio_chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, swarren@nvidia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 5:06 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Initialize the gpio chip's of_node to the device's node
> to work with DT based system.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Applied.

I will not send this to the -rc:s unless you tell me it's urgent...
I couldn't quite tell if it was.

Yours,
Linus Walleij
