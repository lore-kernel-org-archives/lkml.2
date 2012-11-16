Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab2KPFsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 00:48:17 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63041 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2KPFsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 00:48:15 -0500
Message-ID: <50A5D39B.4090007@pobox.com>
Date: Fri, 16 Nov 2012 00:48:11 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.linux@gmail.com>,
        linux-ide@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/5] ata: suspend/resume callbacks should be conditionally
 compiled on CONFIG_PM_SLEEP
References: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
In-Reply-To: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 10:59 AM, Yuanhan Liu wrote:
> This will fix warnings like following when CONFIG_PM_SLEEP is not set:
>
>          warning: 'xxx_suspend' defined but not used [-Wunused-function]
>          warning: 'xxx_resume' defined but not used [-Wunused-function]
>
> Because
> 	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
>
> Only references the callbacks on CONFIG_PM_SLEEP (instead of CONFIG_PM).
>
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Cc: Viresh Kumar <viresh.linux@gmail.com>
> Cc: linux-ide@vger.kernel.org
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>   drivers/ata/ahci_platform.c  |    2 +-
>   drivers/ata/pata_arasan_cf.c |    2 +-
>   drivers/ata/sata_highbank.c  |    2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)


applied



