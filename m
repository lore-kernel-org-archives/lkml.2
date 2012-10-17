Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab2JQDjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 23:39:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49399 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2JQDjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 23:39:42 -0400
MIME-Version: 1.0
In-Reply-To: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
Date: Wed, 17 Oct 2012 09:09:42 +0530
X-Google-Sender-Auth: 6fCSDhyRUNwzvea0ujKKyVRV1mo
Message-ID: <CAOh2x=nDAJF7m6Xf1d9DdXsJTkAHLkhOrjo+W3+G2nGGpcpqhw@mail.gmail.com>
Subject: Re: [PATCH 1/5] ata: suspend/resume callbacks should be conditionally
 compiled on CONFIG_PM_SLEEP
From: viresh kumar <viresh.kumar@linaro.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        linux-pm@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 8:29 PM, Yuanhan Liu
<yuanhan.liu@linux.intel.com> wrote:
> This will fix warnings like following when CONFIG_PM_SLEEP is not set:
>
>         warning: 'xxx_suspend' defined but not used [-Wunused-function]
>         warning: 'xxx_resume' defined but not used [-Wunused-function]
>
> Because
>         SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
>
> Only references the callbacks on CONFIG_PM_SLEEP (instead of CONFIG_PM).
>
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Cc: Viresh Kumar <viresh.linux@gmail.com>
> Cc: linux-ide@vger.kernel.org
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  drivers/ata/ahci_platform.c  |    2 +-
>  drivers/ata/pata_arasan_cf.c |    2 +-

For pata_arasan:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

--
viresh
