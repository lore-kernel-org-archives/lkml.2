Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1HBTwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab1HBTwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:52:51 -0400
Date: Tue, 2 Aug 2011 15:52:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
Message-ID: <20110802195249.GB3593@redhat.com>
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 08:56:30AM +0200, Francis Moreau wrote:
> Hello,
> 
> I'm seeing those kernel message when resuming:
> 
> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
> [  524.973288] Do you have a strange power saving mode enabled?
> [  524.973289] Dazed and confused, but trying to continue
> 
> I don't know if it's important or not because the system seems to work
> after but maybe it worths to report

Depends on what you were doing when this happened and if it is repeatable?

If it is from perf/nmi_watchdog it probably isn't that big of a deal
(though we should fix it).  Otherwise it could be a hardware failure.

Can you attach a dmesg log?

Cheers,
Don
