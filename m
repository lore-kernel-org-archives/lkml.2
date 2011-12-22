Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab1LVQPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:15:15 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59260 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab1LVQPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:15:12 -0500
MIME-Version: 1.0
In-Reply-To: <20111222113916.GA2625@localhost>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
	<1324341747-5922-3-git-send-email-felipe.contreras@gmail.com>
	<20111222113916.GA2625@localhost>
Date: Thu, 22 Dec 2011 18:15:11 +0200
Message-ID: <CAMP44s3qhLNRv6e7GJY-pGigv-fqeFZw1zfqOqHThL0nV5tegg@mail.gmail.com>
Subject: Re: [PATCH 02/10] arm: vexpress: fix kconfig warning
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Felipe Balbi <balbi@ti.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "Uwe Kleine-K??nig" <u.kleine-koenig@pengutronix.de>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 1:39 PM, Dave Martin <dave.martin@linaro.org> wrote:
> NAK -- I hit this problem too, but in fact the errata configs should not
> really be dependent on SMP; these are fixed in a couple of patches
> currently queued in Russell's patch system:
>
> 7196/1 - errata: remove SMP dependency for erratum 720789
> 7197/1 - errata: remove SMP dependency for erratum 751472
>
> ...so we should avoid duplicating knowledge about exactly what these
> errata workarounds do, where it can be avoided.
>
> In the meantime, the warning is harmless.

All right.

-- 
Felipe Contreras
