Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0FIGgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 02:36:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47547 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0FIGgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 02:36:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ai0wGwlZSfBGWScYCNhUehktCLFp8ZprX2OJc0h2+vZN7BMvazXIg0/2X8PdfW1gEn
         9uuysUVbtoKUsrI/PBRKHlCTKjMb9WT5wAD/XCCee0vFYqUpJijQO9h9LRAtdyHVi4fd
         9oAwMa5ouj4Dv3thazPRF+uinLq3r5kNL9JZw=
Subject: Re: 2.6.35-rc2-git2: Reported regressions from 2.6.34
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Carl Worth <cworth@cworth.org>,
       Eric Anholt <eric@anholt.net>, Venkatesh Pallipadi <venki@google.com>,
       Jens Axboe <jaxboe@fusionio.com>, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
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
In-Reply-To: <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
	 <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 08:36:12 +0200
Message-ID: <1276065372.2439.700.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 08 juin 2010 à 18:53 -0700, Linus Torvalds a écrit :

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16120
> > Subject	: Oops: 0000 [#1] SMP, unable to handle kernel NULL pointer dereference at (null)
> > Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
> > Date		: 2010-06-04 09:25 (5 days old)
> > Handled-By	: Eric Dumazet <eric.dumazet@gmail.com>
> 
> This one seems to have a patch in bugzilla.

Yep, commit 035320d54758e21227987e3aae0d46e7a04f4ddc in David net-2.6
tree, i'll be included in its next pull request.

http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=035320d54758e21227987e3aae0d46e7a04f4ddc

Thanks


