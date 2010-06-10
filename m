Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab0FJWhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 18:37:21 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51730 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759433Ab0FJWhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 18:37:19 -0400
Date: Thu, 10 Jun 2010 16:37:03 -0600
From: Alex Chiang <achiang@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.35-rc2-git2: Reported regressions from 2.6.34
Message-ID: <20100610223703.GF8257@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
 <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org>:
> On Wed, 9 Jun 2010, Rafael J. Wysocki wrote:
> > Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=16161
> > Subject       : [2.6.35-rc1 regression] sysfs: cannot create duplicate filename ... XVR-600 related?
> > Submitter     : Mikael Pettersson <mikpe@it.uu.se>
> > Date          : 2010-06-01 19:57 (8 days old)
> > Message-ID    : <19461.26166.427857.612983@pilspetsen.it.uu.se>
> > References    : http://marc.info/?l=linux-kernel&m=127542227511925&w=2
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16090
> > Subject	: sysfs: cannot create duplicate filename
> > Submitter	: Tobias <devnull@plzk.org>
> > Date		: 2010-06-01 15:59 (8 days old)
> > Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> These two look related. Both are related to that "slot" thing in sysfs 
> PCI, but only one of them is marked as Jesse's. Jesse?

Both related, yes.

I asked Jesse to revert the patch, so expect that to come
shortly.

Thanks,
/ac
