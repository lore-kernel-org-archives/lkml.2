Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1KKOih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 09:38:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47725 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab1KKOig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 09:38:36 -0500
MIME-Version: 1.0
In-Reply-To: <1320092872-6120-1-git-send-email-marek.belisko@open-nandra.com>
References: <CACRpkdZ1Y1sHh1oQKFVYUEftyZnJnuUGLmXUHg3vaZKbSfra2Q@mail.gmail.com>
	<1320092872-6120-1-git-send-email-marek.belisko@open-nandra.com>
Date: Fri, 11 Nov 2011 15:38:35 +0100
Message-ID: <CACRpkdb_ww5r9opTEsNQB-Q1GYM=gboNPcoTPmrtTJMWdSJvKQ@mail.gmail.com>
Subject: Re: [PATH v2 2/2] pinmux: Unify pin type from signed to unsigned.
From: Linus Walleij <linus.walleij@linaro.org>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: swarren@nvidia.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 9:27 PM, Marek Belisko
<marek.belisko@open-nandra.com> wrote:

> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> ---
>  drivers/pinctrl/core.c |    2 +-
>  drivers/pinctrl/core.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Thanks, applied.

Linus Walleij
