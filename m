Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2AJJQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:16:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39818 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2AJJQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:16:52 -0500
MIME-Version: 1.0
In-Reply-To: <1325882311-7504-1-git-send-email-swarren@nvidia.com>
References: <1325882311-7504-1-git-send-email-swarren@nvidia.com>
Date: Tue, 10 Jan 2012 10:16:52 +0100
Message-ID: <CACRpkdY+qpm1na_fdSEiSeBPQNFYf4JTapVE5o6m07OQiaoPCw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Fix pinconf_pins_show iteration
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 9:38 PM, Stephen Warren <swarren@nvidia.com> wrote:

> Commit 706e852 "pinctrl: correct a offset while enumerating pins"
> modified the variable used by pinconf_pin_show()'s for loop, but didn't
> update the for loop test expression.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

OK applied to my fixes branch, will send this along with any other
fixes once Torvalds has pulled the pinctrl tree for this merge window.

Yours,
Linus Walleij
