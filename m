Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab0HJNgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 09:36:14 -0400
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:38021 "EHLO
	smtp.towertech.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab0HJNgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 09:36:10 -0400
Date: Tue, 10 Aug 2010 15:34:48 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: wellsk40@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Durgesh Pattamatta <durgesh.pattamatta@nxp.com>
Subject: Re: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver
 for  the LPC32XX SoC
Message-ID: <20100810153448.17443314@linux.lan.towertech.it>
In-Reply-To: <1281370650-29520-2-git-send-email-wellsk40@gmail.com>
References: <1281370650-29520-1-git-send-email-wellsk40@gmail.com>
	<1281370650-29520-2-git-send-email-wellsk40@gmail.com>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Aug 2010 09:17:29 -0700
wellsk40@gmail.com wrote:

> +
> +	retval = request_irq(rtc->irq, lpc32xx_rtc_alarm_interrupt,
> +		IRQF_DISABLED, "rtcalarm", rtc);
> +	if (retval < 0) {
> +		dev_err(&pdev->dev, "Can't request interrupt\n");
> +		goto err_free_irq;
> +	}

 if the driver can work without the alarm irq you
 can convert this to a non fatal warning.

 having an rtc without alarms is much better than having none.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

