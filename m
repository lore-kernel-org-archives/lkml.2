Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab1LAXze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:55:34 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:44431 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab1LAXzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:55:33 -0500
Message-ID: <1322783723.21423.150.camel@work-vm>
Subject: Re: [PATCH 2/3] clocksource: dbx500: convert to
 clocksource_register_hz()
From: John Stultz <john.stultz@linaro.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Date: Thu, 01 Dec 2011 15:55:23 -0800
In-Reply-To: <1322724016-9770-3-git-send-email-yong.zhang0@gmail.com>
References: <1322724016-9770-1-git-send-email-yong.zhang0@gmail.com>
	 <1322724016-9770-3-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11120123-1780-0000-0000-0000015BC64D
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000236; HX=3.00000178; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00092455; UDB=6.00024463; UTC=2011-12-01
 23:55:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 15:20 +0800, Yong Zhang wrote:
> Convert clocksource_dbx500_prcmu to use clocksource_register_hz.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mattias Wallin <mattias.wallin@stericsson.com>
> ---

Acked-by: John Stultz <john.stultz@linaro.org>

I've queued this myself, but I'd prefer it to go through the appropriate
maintainer. That said, if I don't see it in -next in a week or so, I'll
go ahead and add it to my 3.3 list for Thomas.

thanks
-john


