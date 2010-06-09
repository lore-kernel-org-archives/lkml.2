Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab0FII7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:59:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41233 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab0FII67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:58:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: 2.6.35-rc2-git2: Reported regressions from 2.6.34
Date: Wed, 9 Jun 2010 11:00:32 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Carl Worth <cworth@cworth.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venki@google.com>,
       Jens Axboe <jaxboe@fusionio.com>, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       David =?iso-8859-15?q?H=E4rdeman?= <david@hardeman.nu>,
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
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera> <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org> <4C0EFBC1.5090401@redhat.com>
In-Reply-To: <4C0EFBC1.5090401@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006091100.32494.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 June 2010, Mauro Carvalho Chehab wrote:
> Em 08-06-2010 22:53, Linus Torvalds escreveu:
> 
> > 
> >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16037
> >> Subject	: NULL Pointer dereference in __ir_input_register/budget_ci_attach
> >> Submitter	: Sean Finney <seanius@debian.org>
> >> Date		: 2010-05-23 19:52 (17 days old)
> > 
> > Perhaps related to commit 13c24497086418010bf4f76378bcae241d7f59cd?
> > 
> > David Härdeman, Mauro Carvalho Chehab added to cc.
> 
> This patch probably solves the issue:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=84b14f181a36eea6591779156ef356f8d198bbfd
> 
> The patch were already applied upstream. I've already asked the reporter to test it, via BZ.

Confirmed fixed, so closing.

Thanks,
Rafael
