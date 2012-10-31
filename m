Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161078Ab2JaJDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:03:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161033Ab2JaJDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:03:15 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: john.stultz@linaro.org, tglx@linutronix.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Subject: Re: [PATCH 1/3] alarmtimer: Replace the spinlock rtcdev_lock with mutex
Date: Wed, 31 Oct 2012 10:03:13 +0100
Message-ID: <2035297.QqCM5sVoD5@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.7.0-rc3-12-desktop+; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1351700455.15558.1571.camel@cliu38-desktop-build>
References: <1351700455.15558.1571.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2012 00:20:55 Chuansheng Liu wrote:
> When do code reviewing, found no special requirement to
> use spin_lock_irqsave/spin_unlock_irqrestore, because
> alarmtimer_get_rtcdev() is called by posix clock interface.
> So would like to use mutex to replace it.

What is gained thereby?

	Regards
		Oliver

