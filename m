Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0JRMKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:10:49 -0400
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:49577 "EHLO
	smtp.towertech.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab0JRMKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:10:48 -0400
Date: Mon, 18 Oct 2010 14:10:56 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 4/6] [RFC] RTC: Rework RTC code to use timerlist for
 events
Message-ID: <20101018141056.0b916878@linux.lan.towertech.it>
In-Reply-To: <1287189535-24649-5-git-send-email-john.stultz@linaro.org>
References: <1287189535-24649-1-git-send-email-john.stultz@linaro.org>
	<1287189535-24649-2-git-send-email-john.stultz@linaro.org>
	<1287189535-24649-3-git-send-email-john.stultz@linaro.org>
	<1287189535-24649-4-git-send-email-john.stultz@linaro.org>
	<1287189535-24649-5-git-send-email-john.stultz@linaro.org>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 17:38:53 -0700
John Stultz <john.stultz@linaro.org> wrote:

> This patch reworks a large portion of the generic RTC code
> to in-effect virtualize the rtc interrupt code.
> 
> The current RTC interface is very much a raw hardware interface.
> Via the proc, /dev/, or sysfs interfaces, applications can set
> the hardware to trigger interrupts in one of three modes:

 [...]


 If everything still works after all those changes,
 it seems a good thing to me ;)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

