Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1HDRSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 13:18:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46722 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab1HDRSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 13:18:44 -0400
Date: Thu, 4 Aug 2011 19:17:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jin Park <jinyoungp@nvidia.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: aat2870 causes build failure in current upstream
Message-ID: <20110804171725.GA12729@elte.hu>
References: <4E385B53.3040108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E385B53.3040108@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Doing an "allmodconfig" on i386:
> 
> drivers/built-in.o: In function `aat2870_bl_remove':
> /home/hpa/kernel/git.test/drivers/video/backlight/aat2870_bl.c:217:
> undefined reference to `backlight_device_unregister'
> drivers/built-in.o: In function `aat2870_bl_probe':
> /home/hpa/kernel/git.test/drivers/video/backlight/aat2870_bl.c:159:
> undefined reference to `backlight_device_register'
> /home/hpa/kernel/git.test/drivers/video/backlight/aat2870_bl.c:201:
> undefined reference to `backlight_device_unregister'
> make[2]: *** [.tmp_vmlinux1] Error 1
> make[1]: *** [sub-make] Error 2
> make[1]: Leaving directory `/home/hpa/kernel/git.test'

The allmodconfig build is still broken upstream.

Thanks,

	Ingo
