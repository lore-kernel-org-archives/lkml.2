Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab1DGCPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:15:50 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41860 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab1DGCPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:15:49 -0400
Subject: Re: [PATCH 1/2] rtc: rtc-mrst: follow on to the change of
 rtc_device_register()
From: john stultz <johnstul@us.ibm.com>
To: Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, alan@linux.intel.com,
        Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <1302140384-27571-1-git-send-email-feng.tang@intel.com>
References: <1302140384-27571-1-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 19:15:42 -0700
Message-ID: <1302142542.2319.97.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 09:39 +0800, Feng Tang wrote:
> commit f44f7f96a20 (RTC: Initialize kernel state from RTC) will
> call rtc_read_alarm() inside rtc_device_register(), so rtc-mrst
> driver need to call dev_set_drvdata() before rtc_device_register()
> get called.
> 
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Feng Tang <feng.tang@intel.com>

Thanks, I'll add this to my queue!

-john


