Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab2I3Iaq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:30:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39965 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2I3Iam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:30:42 -0400
MIME-Version: 1.0
In-Reply-To: <1348624007-16634-1-git-send-email-zhangwm@marvell.com>
References: <1348624007-16634-1-git-send-email-zhangwm@marvell.com>
Date: Sun, 30 Sep 2012 10:30:41 +0200
Message-ID: <CACRpkdZTuftPEGHG3ibOJbnG5q05LpUC+anYr8tQdtM_C=7GpA@mail.gmail.com>
Subject: Re: [PATCH V2] GPIO: gpio-pxa: fix bug when get gpio value
From: Linus Walleij <linus.walleij@linaro.org>
To: Neil Zhang <zhangwm@marvell.com>
Cc: grant.likely@secretlab.ca, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 3:46 AM, Neil Zhang <zhangwm@marvell.com> wrote:

> We need to return 0 or 1 when get gpio value.
>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>

Aha there is another patch fixing that comment I had, sorry, going through
the mail backlog.

But you need to take Haojian's comments into account so I'm not applying
it right now.

Yours,
Linus Walleij
