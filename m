Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0I2BNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 21:13:12 -0400
Received: from xenotime.net ([72.52.115.56]:52016 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751941Ab0I2BNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 21:13:11 -0400
Date: Tue, 28 Sep 2010 18:13:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com>
Cc: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2010-09-28-16-13 uploaded
Message-Id: <20100928181304.74bbfc79.rdunlap@xenotime.net>
In-Reply-To: <AANLkTim4BKvyyEbS6fp52FcjZzL_gVgSe7=ra2pA9ObR@mail.gmail.com>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTim4BKvyyEbS6fp52FcjZzL_gVgSe7=ra2pA9ObR@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 02:49:57 +0200 N.P.S. N.P.S. wrote:

> 2010/9/29  <akpm@linux-foundation.org>:
> > The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
> 
> It seems that randconfig causes a problem
> 
> drivers/hwmon/pkgtemp.c: In function 'pkgtemp_init':
> drivers/hwmon/pkgtemp.c:413: error: 'pkgtemp_cpu_notifier' undeclared (first use
> drivers/hwmon/pkgtemp.c:413: error: (Each undeclared identifier is reported only
> drivers/hwmon/pkgtemp.c:413: error: for each function it appears in.)
> make[2]: *** [drivers/hwmon/pkgtemp.o] Błąd 1
> make[1]: *** [drivers/hwmon] Błąd 2
> make: *** [drivers] Błąd 2

I sent a patch for this in reply to today's linux-next announcement.

Same for the fs.h warnings.  And several others that are needed in mmotm
due to its base.

Andrew, should I be cc-ing you on all of these patches?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
