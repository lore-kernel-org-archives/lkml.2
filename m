Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2BPS7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:59:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52273 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2BPS7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:59:12 -0500
MIME-Version: 1.0
In-Reply-To: <1329241841-21357-1-git-send-email-swarren@nvidia.com>
References: <1329241841-21357-1-git-send-email-swarren@nvidia.com>
Date: Thu, 16 Feb 2012 19:59:12 +0100
Message-ID: <CACRpkdbrOX4yjjDr1xdSOZMafdnZnXQMwRgF7TFiC1uVYXLhaA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Make "hog" mapping table entries work
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 6:50 PM, Stephen Warren <swarren@nvidia.com> wrote:

> Commit 77a5988 "pinctrl: changes hog mechanism to be self-referential"
> modified the way "hog" entries were represented in the mapping table.
> However, the new representation failed some error checks in
> pinctrl_hog_map(). Remove the now-bogus error-check, and fix the code
> to solve the issue the error-check used to avoid.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Nice catch! Applied with Dong's ACK.

Yours,
Linus Walleij
