Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2F1QBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:01:16 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34505 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2F1QBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:01:14 -0400
MIME-Version: 1.0
In-Reply-To: <1340232467-6023-10-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
	<1340232467-6023-10-git-send-email-john.stultz@linaro.org>
Date: Thu, 28 Jun 2012 18:01:13 +0200
Message-ID: <CACRpkdY2CSMuDSv6Cj4J8YkLfagK31DEhWiupth9zFSpu1QNLA@mail.gmail.com>
Subject: Re: [PATCH 09/15] ARM: etm: Power down etm(s) when tracing is not enabled
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
> Without this change a saw an 18% increase in idle power consumption
> on one deivce when trace support is compiled into the kernel. Now
> I see the same increase only when tracing.
>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Paul Gortmaker <paul.gortmaker@windriver.com>
> CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

We can't have this no.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
