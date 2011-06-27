Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab1F0HeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:34:24 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:43081 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab1F0HdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:33:22 -0400
X-ASG-Debug-ID: 1309160001-03d6a510aabb150001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E08323D.7090004@fusionio.com>
Date: Mon, 27 Jun 2011 09:33:17 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #38122] 3.0-rc3 WARNING: at  drivers/gpu/drm/i915/i915_drv.c:340
 gen6_gt_force_wake_put+0x29/0x52 [i915]()
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera> <XWjMN7gBoXK.A.ULD.cZ6BOB@chimera>
X-ASG-Orig-Subj: Re: [Bug #38122] 3.0-rc3 WARNING: at  drivers/gpu/drm/i915/i915_drv.c:340
 gen6_gt_force_wake_put+0x29/0x52 [i915]()
In-Reply-To: <XWjMN7gBoXK.A.ULD.cZ6BOB@chimera>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1309160001
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.12
X-Barracuda-Spam-Status: No, SCORE=0.12 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=CN_BODY_332, INFO_TLD
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.67253
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
	0.00 INFO_TLD               URI: Contains an URL in the INFO top-level domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-26 23:23, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.39.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38122
> Subject		: 3.0-rc3 WARNING: at drivers/gpu/drm/i915/i915_drv.c:340 gen6_gt_force_wake_put+0x29/0x52 [i915]()
> Submitter	: Jens Axboe <jaxboe@fusionio.com>
> Date		: 2011-06-14 12:12 (13 days old)
> Message-ID	: <<4DE3E2C9.6060207@fusionio.com>>
> References	: http://marc.info/?l=linux-kernel&m=130805412314680&w=2
> 		  https://lkml.org/lkml/2011/5/30/261

By the looks of it, commit 483f1798 should fix it.

-- 
Jens Axboe

