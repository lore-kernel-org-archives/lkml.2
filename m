Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1CHRGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 12:06:08 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:57668 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab1CHRGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 12:06:03 -0500
Subject: Re: [PATCH] rtc/at91sam9: fix typo .alarm_irq_enabled instead of
 .alarm_irq_enable
From: John Stultz <john.stultz@linaro.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <1299601173-26252-1-git-send-email-plagnioj@jcrosoft.com>
References: <1299601173-26252-1-git-send-email-plagnioj@jcrosoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 09:05:53 -0800
Message-ID: <1299603953.28285.215.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 17:19 +0100, Jean-Christophe PLAGNIOL-VILLARD
wrote:
> in struct rtc_class_ops at91_rtc_ops
> 
> introduce in commit 16380c153a6
> RTC: Convert rtc drivers to use the alarm_irq_enable method

I believe this fix is already upstream:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d40358509ee862d7e4049187bc05eba1911a2959


thanks
-john


