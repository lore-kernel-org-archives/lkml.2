Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab0I2FyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:54:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907Ab0I2FyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:54:14 -0400
Date: Tue, 28 Sep 2010 22:55:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2010-09-28-16-13 uploaded
Message-Id: <20100928225516.89145c80.akpm@linux-foundation.org>
In-Reply-To: <20100928181304.74bbfc79.rdunlap@xenotime.net>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTim4BKvyyEbS6fp52FcjZzL_gVgSe7=ra2pA9ObR@mail.gmail.com>
	<20100928181304.74bbfc79.rdunlap@xenotime.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 18:13:04 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Wed, 29 Sep 2010 02:49:57 +0200 N.P.S. N.P.S. wrote:
> 
> > 2010/9/29  <akpm@linux-foundation.org>:
> > > The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
> > 
> > It seems that randconfig causes a problem
> > 
> > drivers/hwmon/pkgtemp.c: In function 'pkgtemp_init':
> > drivers/hwmon/pkgtemp.c:413: error: 'pkgtemp_cpu_notifier' undeclared (first use
> > drivers/hwmon/pkgtemp.c:413: error: (Each undeclared identifier is reported only
> > drivers/hwmon/pkgtemp.c:413: error: for each function it appears in.)
> > make[2]: *** [drivers/hwmon/pkgtemp.o] B____d 1
> > make[1]: *** [drivers/hwmon] B____d 2
> > make: *** [drivers] B____d 2
> 
> I sent a patch for this in reply to today's linux-next announcement.
> 
> Same for the fs.h warnings.  And several others that are needed in mmotm
> due to its base.
> 
> Andrew, should I be cc-ing you on all of these patches?
> 

Yes please - if we can save people from discovering and reporting
already-fixed bugs then I'm all for it!

