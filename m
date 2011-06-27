Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1F0TSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 15:18:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab1F0TSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 15:18:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [Bug #38122] 3.0-rc3 WARNING: at  drivers/gpu/drm/i915/i915_drv.c:340 gen6_gt_force_wake_put+0x29/0x52 [i915]()
Date: Mon, 27 Jun 2011 21:19:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera> <XWjMN7gBoXK.A.ULD.cZ6BOB@chimera> <4E08323D.7090004@fusionio.com>
In-Reply-To: <4E08323D.7090004@fusionio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106272119.15301.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 27, 2011, Jens Axboe wrote:
> On 2011-06-26 23:23, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.39.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38122
> > Subject		: 3.0-rc3 WARNING: at drivers/gpu/drm/i915/i915_drv.c:340 gen6_gt_force_wake_put+0x29/0x52 [i915]()
> > Submitter	: Jens Axboe <jaxboe@fusionio.com>
> > Date		: 2011-06-14 12:12 (13 days old)
> > Message-ID	: <<4DE3E2C9.6060207@fusionio.com>>
> > References	: http://marc.info/?l=linux-kernel&m=130805412314680&w=2
> > 		  https://lkml.org/lkml/2011/5/30/261
> 
> By the looks of it, commit 483f1798 should fix it.

Thanks for the info, closed already.

Take care,
Rafael
