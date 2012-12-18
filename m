Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab2LRJJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:09:10 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44449 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab2LRJJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:09:08 -0500
MIME-Version: 1.0
In-Reply-To: <005201cddcfc$36ac4020$a404c060$%han@samsung.com>
References: <005201cddcfc$36ac4020$a404c060$%han@samsung.com>
Date: Tue, 18 Dec 2012 04:09:05 -0500
Message-ID: <CAHdPZaM=kgcD8tO-tVcFX=pz1CU2s7Deb+BEkF0Oz=QDr=t+xQ@mail.gmail.com>
Subject: Re: [PATCH v2] backlight: add lms501kf03 LCD driver
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>, Joe Perches <joe@perches.com>,
        Ilho Lee <ilho215.lee@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 3:46 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> Add the lms501kf03 LCD panel driver. The lms501kf03 LCD panel (800
> x 480) driver uses 3-wired SPI inteface.
>
> Signed-off-by: Ilho Lee <Ilho215.lee@samsung.com>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Change since v1:
> - remove redundant return variables
> - use -EINVAL instead of -EFAULT
> - add a more detailed description of 120ms delay time


Thanks for taking care of these comments!
