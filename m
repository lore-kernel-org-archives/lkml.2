Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0I2PA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:00:58 -0400
Received: from xenotime.net ([72.52.115.56]:53477 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751386Ab0I2PA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:00:56 -0400
Date: Wed, 29 Sep 2010 08:00:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com>
Cc: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2010-09-28-16-13 uploaded
Message-Id: <20100929080052.ceaf6727.rdunlap@xenotime.net>
In-Reply-To: <AANLkTikXgtFtBE_EM3izNR5H-ug4hhfa19PMvQLftD8s@mail.gmail.com>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTikXgtFtBE_EM3izNR5H-ug4hhfa19PMvQLftD8s@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 11:15:32 +0200 N.P.S. N.P.S. wrote:

> 2010/9/29  <akpm@linux-foundation.org>:
> > The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
> >
> 
> 
> drivers/base/core.c: In function 'get_device_parent':
> drivers/base/core.c:634: error: 'block_class' undeclared (first use in
> this function)
> drivers/base/core.c:634: error: (Each undeclared identifier is
> reported only once
> drivers/base/core.c:634: error: for each function it appears in.)
> drivers/base/core.c: In function 'device_add_class_symlinks':
> drivers/base/core.c:723: error: 'block_class' undeclared (first use in
> this function)
> drivers/base/core.c: In function 'device_remove_class_symlinks':
> drivers/base/core.c:751: error: 'block_class' undeclared (first use in
> this function)
> make[2]: *** [drivers/base/core.o] Błąd 1
> make[1]: *** [drivers/base] Błąd 2
> make: *** [drivers] Błąd 2

Patch has been sent to GregKH for this one.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
