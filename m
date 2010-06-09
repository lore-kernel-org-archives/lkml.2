Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab0FIOZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 10:25:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757788Ab0FIOZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 10:25:42 -0400
Date: Wed, 9 Jun 2010 07:24:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Carl Worth <cworth@cworth.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venki@google.com>,
       Jens Axboe <jaxboe@fusionio.com>, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?David__H=E4rdeman?= <david@hardeman.nu>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.35-rc2-git2: Reported regressions from 2.6.34
In-Reply-To: <201006091106.11232.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1006090719440.4506@i5.linux-foundation.org>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera> <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org> <201006091106.11232.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, Rafael J. Wysocki wrote:
> > 
> > That has a "reverting the commit fixes it", and a confirmation from Nick 
> > Bowler.
> > 
> > Eric, Carl: should I just revert that commit? Or do you have a fix?
> 
> This one is reported to have been fixed already.  Closed now.

Heh. That "fixed already" is actually the revert. Carl acked it.

> This should be fixed by commit f8ed8b4c5d30b5214f185997131b06e35f6f7113, so
> closing now.

Good, that was in yesterday's drm pull.

		Linus
