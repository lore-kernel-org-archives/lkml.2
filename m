Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2F1Ptb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 11:49:31 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33919 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2F1Pt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 11:49:29 -0400
MIME-Version: 1.0
In-Reply-To: <1340232467-6023-3-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
	<1340232467-6023-3-git-send-email-john.stultz@linaro.org>
Date: Thu, 28 Jun 2012 17:49:28 +0200
Message-ID: <CACRpkdbFQANHypyT0JkCHG7P2wQB6sjdULX5qmOr7gcAf_ZF3A@mail.gmail.com>
Subject: Re: [PATCH 02/15] ARM: etm: Don't limit tracing to only non-secure code.
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
> On some systems kernel code is considered secure, and this code
> already limits tracing to the kernel text segment which results
> in no trace data.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
