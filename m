Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2ILI1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:27:19 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56387 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab2ILI1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <1344587555-8454-1-git-send-email-linus.walleij@stericsson.com>
References: <1344587555-8454-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 12 Sep 2012 10:27:13 +0200
Message-ID: <CACRpkdasO8ZCunW_J3_CGT1D3t4NK5ZsDL8EXRBWz=htfims1A@mail.gmail.com>
Subject: Re: [PATCH] mfd/ab3100: split ab3100 headers out of abx500.h
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 10:32 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Marcus Cooper <marcus.xm.cooper@stericsson.com>
>
> The U8500 has its own set of separate header, so the abx500
> becomes completely abstract. Do the same split for the AB3100
> legacy ASIC.
>
> Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Sam, are you picking this to the MFD tree?

Yours,
Linus Walleij
