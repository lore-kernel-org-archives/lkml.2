Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637Ab0JSAAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:00:08 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:54690 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867Ab0JSAAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:00:06 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: arnd@arndb.de
Subject: linux-next: user mode linux build failure (2)
Date: Tue, 19 Oct 2010 02:00:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010190200.01496.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

1e3d8715 (uml: kill big kernel lock) breaks um build.

arch/um/drivers/ubd_kern.c: In function 'ubd_open':
arch/um/drivers/ubd_kern.c:1104: error: 'ubd_mutex' undeclared (first use in 
this function)
arch/um/drivers/ubd_kern.c:1104: error: (Each undeclared identifier is 
reported only once
arch/um/drivers/ubd_kern.c:1104: error: for each function it appears in.)
arch/um/drivers/ubd_kern.c: In function 'ubd_release':
arch/um/drivers/ubd_kern.c:1131: error: 'ubd_mutex' undeclared (first use in 
this function)
make[1]: *** [arch/um/drivers/ubd_kern.o] Error 1
make: *** [arch/um/drivers] Error 2

It seems you forgot to define ubd_mutex in ubd_kern.c.

Thanks,
//richard
