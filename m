Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab2LQTcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:32:21 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62918 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2LQTcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:32:20 -0500
Date: Mon, 17 Dec 2012 11:28:54 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time: create __getnstimeofday for WARNless calls
Message-ID: <20121217192806.GA10376@lizard.gateway.2wire.net>
References: <1355770314-9167-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355770314-9167-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 01:51:54PM -0500, John Stultz wrote:
> From: Kees Cook <keescook@chromium.org>
> 
> Hey Thomas, 
>    Wanted to see if maybe there was still time for this for 3.8?
> thanks
> -john
> 
> The pstore RAM backend can get called during resume, and must be defensive
> against a suspended time source. Expose getnstimeofday logic that returns
> an error instead of a WARN. This can be detected and the timestamp can
> be zeroed out.
> 
> Reported-by: Doug Anderson <dianders@chromium.org>
> Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  fs/pstore/ram.c           |   10 +++++++---

For pstore/ram part:

Acked-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Thanks!
