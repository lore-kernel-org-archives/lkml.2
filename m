Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab1JJObg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:31:36 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49039 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab1JJObf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:31:35 -0400
MIME-Version: 1.0
Date: Mon, 10 Oct 2011 22:31:34 +0800
Message-ID: <CACVXFVOkwX+974=eEY5UPysXN-t9Adg6=Wn0Ts4m0vT5zQaw3g@mail.gmail.com>
Subject: [Question] PM-QoS: PM_QOS_CPU_DMA_LATENCY == interrupt latency?
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <mgross@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks like it is a bit difficult to understand PM_QOS_CPU_DMA_LATENCY
from the words' meaning.

After searching from google, I don't find some useful information about
the root cause for introducing PM_QOS_CPU_DMA_LATENCY. I understand
it is very similar to interrupt latency. Also from the comment for
omap_pm_set_max_mpu_wakeup_lat in file[1], the description is basically same
with interrupt latency.

>From comments of pm_qos_add_request usages in drivers, it can be understood
as interrupt latency too, IMO.

So, could we think that PM_QOS_CPU_DMA_LATENCY is interrupt latency?


[1], arch/arm/plat-omap/include/plat/omap-pm.h

thanks,
-- 
Ming Lei
