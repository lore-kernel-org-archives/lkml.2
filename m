Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab0FIC12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 22:27:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab0FIC1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 22:27:25 -0400
Message-ID: <4C0EFBC1.5090401@redhat.com>
Date: Tue, 08 Jun 2010 23:26:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Carl Worth <cworth@cworth.org>,
       Eric Anholt <eric@anholt.net>, Venkatesh Pallipadi <venki@google.com>,
       Jens Axboe <jaxboe@fusionio.com>, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?David_H=E4rdeman?= <david@hardeman.nu>,
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
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera> <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 08-06-2010 22:53, Linus Torvalds escreveu:

> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16037
>> Subject	: NULL Pointer dereference in __ir_input_register/budget_ci_attach
>> Submitter	: Sean Finney <seanius@debian.org>
>> Date		: 2010-05-23 19:52 (17 days old)
> 
> Perhaps related to commit 13c24497086418010bf4f76378bcae241d7f59cd?
> 
> David Härdeman, Mauro Carvalho Chehab added to cc.

This patch probably solves the issue:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=84b14f181a36eea6591779156ef356f8d198bbfd

The patch were already applied upstream. I've already asked the reporter to test it, via BZ.

Cheers,
Mauro
