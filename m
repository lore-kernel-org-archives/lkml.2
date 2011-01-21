Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1AUS4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:56:04 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53160 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab1AUS4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:56:02 -0500
Subject: Re: [PATCH] RTC: remove Kconfig symbol for UIE emulation
From: John Stultz <john.stultz@linaro.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
In-Reply-To: <1295625406-15340-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1290136329-18291-5-git-send-email-john.stultz@linaro.org>
	 <1295625406-15340-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 10:55:54 -0800
Message-ID: <1295636154.1923.0.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 16:56 +0100, Uwe Kleine-König wrote:
> The effect of changing the value of this symbol is gone since
> 
> 	042620a (RTC: Remove UIE emulation)
> 
> so remove symbol, too.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Ah! Thanks for catching that!

Acked-by: John Stultz <john.stultz@linaro.org>


