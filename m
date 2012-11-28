Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2K1J1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:27:33 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35018 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab2K1J1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:27:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Wed, 28 Nov 2012 10:32:15 +0100
Message-ID: <2225929.p7BcZduhEL@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121128150218.5d30531231f7b24e3b398643@canb.auug.org.au>
References: <20121128150218.5d30531231f7b24e3b398643@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 28, 2012 03:02:18 PM Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> ERROR: "devfreq_monitor_resume" [drivers/devfreq/governor_simpleondemand.ko] undefined!
> ERROR: "devfreq_monitor_suspend" [drivers/devfreq/governor_simpleondemand.ko] undefined!
> ERROR: "devfreq_interval_update" [drivers/devfreq/governor_simpleondemand.ko] undefined!
> ERROR: "devfreq_monitor_stop" [drivers/devfreq/governor_simpleondemand.ko] undefined!
> ERROR: "devfreq_monitor_start" [drivers/devfreq/governor_simpleondemand.ko] undefined!
> 
> Caused by commit 206c30cfeb7c ("PM / devfreq: Add suspend and resume apis").
> 
> I have used the pm tree from next-20121127 for today.

Sorry about this, I dropped the devfreq tree from my linux-next branch for now,
but that was after you had pulled from it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
