Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab1CSBSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 21:18:21 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34029 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab1CSBSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 21:18:16 -0400
Subject: Re: [PATCH] rtc-bfin: add missing "return 0" in new alarm func
From: John Stultz <john.stultz@linaro.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <1300436784-26543-1-git-send-email-vapier@gentoo.org>
References: <1300436784-26543-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Mar 2011 18:18:08 -0700
Message-ID: <1300497488.2731.49.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 04:26 -0400, Mike Frysinger wrote:
> The new bfin_rtc_alarm_irq_enable function forgot to add a "return 0" to
> the end leading to the build warning:
> 	drivers/rtc/rtc-bfin.c: In function 'bfin_rtc_alarm_irq_enable':
> 	drivers/rtc/rtc-bfin.c:253: warning: control reaches end of non-void function
> 
> CC: stable@kernel.org
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Thanks for catching this!

Acked-by: John Stultz <john.stultz@linaro.org>



