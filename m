Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3AHOa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:30:26 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:43476 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab3AHOaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:30:25 -0500
MIME-Version: 1.0
In-Reply-To: <1356141435-17340-3-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
	<1356141435-17340-3-git-send-email-tj@kernel.org>
Date: Tue, 8 Jan 2013 15:30:23 +0100
Message-ID: <CACRpkdYeHP6DCDH5XO8EyqAUaQWczqffGKaMEMXXDPVSAE_DWQ@mail.gmail.com>
Subject: Re: [PATCH 02/25] ab8500_charger: don't use [delayed_]work_pending()
From: Linus Walleij <linus.walleij@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Marcus COOPER <marcus.xm.cooper@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 2:56 AM, Tejun Heo <tj@kernel.org> wrote:

> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.
>
> Remove unnecessary pending tests from ab8500_charger.  Only compile
> tested.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Works like a charm for us, thanks!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>

Yours,
Linus Walleij
