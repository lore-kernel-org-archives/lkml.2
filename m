Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2F1QCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:02:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52535 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab2F1QCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <1340232467-6023-11-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
	<1340232467-6023-11-git-send-email-john.stultz@linaro.org>
Date: Thu, 28 Jun 2012 18:02:06 +0200
Message-ID: <CACRpkdY6=k7ny_5V_fZmG7ebCWa+q9ua44FHt4SVjc4jaEipaQ@mail.gmail.com>
Subject: Re: [PATCH 10/15] ARM: etm: Wait for etm/ptm(s) to stop before
 requesting PowerDown
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
> When PowerDown was requested at the same time as ProgBit, the
> formatter flush command that follows could get stuck.
>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Paul Gortmaker <paul.gortmaker@windriver.com>
> CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
