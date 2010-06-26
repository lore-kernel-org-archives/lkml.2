Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0FZBFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 21:05:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50704 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0FZBFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 21:05:19 -0400
Date: Fri, 25 Jun 2010 18:04:51 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       =?UTF-8?Q?Jind=C5=99ich_Makovi=C4=8Dka?= <makovick@gmail.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Grant Likely <grant.likely@secretlab.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
In-Reply-To: <rHrHQMIU4rI.A.5FD.vepHMB@chimera>
Message-ID: <alpine.DEB.2.01.1006251801350.3964@bogon.housecafe.de>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera> <rHrHQMIU4rI.A.5FD.vepHMB@chimera>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX18n2czcSxQN7GetMh8O5oa+eDQzB7r+UQ5d4V2
 k/CCiv+nLiJwxSngP1NOBE6p9I6LGx7YY4UjxpGIC1SsdXLwZZ
 1O6savSP02OBTBtruJseQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply:

On Mon, 21 Jun 2010 at 00:32, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).

Yes, the bug is still present in 2.6.34 and .35-rc3, but a tested patch is 
available, hopefully to be included in 2.6.35.

Thanks,
Christian.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15589
> Subject		: 2.6.34-rc1: Badness at fs/proc/generic.c:316
> Submitter	: Christian Kujau <lists@nerdbynature.de>
> Date		: 2010-03-13 23:53 (100 days old)
> Message-ID	: < <AANLkTikNcCtUn9SQwKu2b3IE6NiAwAhciHsm1HVH4EJh@mail.gmail.com>>
> References	: http://marc.info/?l=linux-kernel&m=126852442903680&w=2
> Handled-By	: Michael Ellerman <michael@ellerman.id.au>
> 		  Jindřich Makovička <makovick@gmail.com>
> Patch		: http://patchwork.ozlabs.org/patch/52978/
> 		  http://lkml.indiana.edu/hypermail/linux/kernel/1006.0/00137.html
-- 
BOFH excuse #302:

microelectronic Riemannian curved-space fault in write-only file system
