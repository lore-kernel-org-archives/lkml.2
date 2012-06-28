Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab2F1P5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 11:57:52 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45744 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2F1P5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 11:57:51 -0400
MIME-Version: 1.0
In-Reply-To: <1340232467-6023-8-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
	<1340232467-6023-8-git-send-email-john.stultz@linaro.org>
Date: Thu, 28 Jun 2012 17:57:50 +0200
Message-ID: <CACRpkdZQ+4xx9-4KOpWR9ienQ2QEgMn1Jgs76urCfFV3KX5CFg@mail.gmail.com>
Subject: Re: [PATCH 07/15] ARM: etm: Return the entire trace buffer if it is
 empty after reset
From: Linus Walleij <linus.walleij@linaro.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 12:47 AM, John Stultz <john.stultz@linaro.org> wrote:

> From: Arve Hjønnevåg <arve@android.com>
>
> On some SOCs the read and write pointer are reset when the chip
> resets, but the trace buffer content is preserved. If the status
> bits indicates that the buffer is empty and we have never started
> tracing, assume the buffer is full instead. This can be useful
> if the system rebooted from a watchdog reset.
>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Paul Gortmaker <paul.gortmaker@windriver.com>
> CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

This looks *very* useful.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
