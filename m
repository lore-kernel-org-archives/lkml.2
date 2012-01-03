Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab2ACH6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:58:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56033 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2ACH6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:58:45 -0500
MIME-Version: 1.0
In-Reply-To: <1325576871-9397-2-git-send-email-chanho61.park@samsung.com>
References: <1325576871-9397-1-git-send-email-chanho61.park@samsung.com>
	<1325576871-9397-2-git-send-email-chanho61.park@samsung.com>
Date: Tue, 3 Jan 2012 08:58:45 +0100
Message-ID: <CACRpkdbnvZo4AN+yoeGwDaJ0yqOJT6VZO_9TmX4ZwdOCOE8Z5w@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: correct a offset while enumerating pins
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Park <chanho61.park@samsung.com>
Cc: swarren@nvidia.com, Baohua.Song@csr.com, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 8:47 AM, Chanho Park <chanho61.park@samsung.com> wrote:

This:

> -               /* Pin space may be sparse */
> +               /* Skip if we cannot search the pin */
(...)
> -               /* Pin space may be sparse */
> +               /* Skip if we cannot search the pin */

I don't see why you're changing that comment, it is still true that
the pin space may be sparse and that is what your patch confirms.

So I will restore that comment...

Yours,
Linus Walleij
