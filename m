Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2F1Pzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 11:55:32 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63713 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2F1Pzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 11:55:31 -0400
MIME-Version: 1.0
In-Reply-To: <1340232467-6023-6-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
	<1340232467-6023-6-git-send-email-john.stultz@linaro.org>
Date: Thu, 28 Jun 2012 17:55:30 +0200
Message-ID: <CACRpkdaQWUFogo=PUdTGGExm7ujuExNMDb7mScAbxL0zVBLbXQ@mail.gmail.com>
Subject: Re: [PATCH 05/15] ARM: etm: Configure data tracing
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
> The old code enabled data tracing, but did not configure the
> range. We now configure it to trace all data addresses by default,
> and add a trace_data_range attribute to change the range or disable
> data tracing.
>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Paul Gortmaker <paul.gortmaker@windriver.com>
> CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

As per same ABI reasoning:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
