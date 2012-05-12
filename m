Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab2ELNC1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 09:02:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab2ELNCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 09:02:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 6/7] scsi/megaraid: fix sparse warnings
Date: Sat, 12 May 2012 13:02:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: mathieu.poirier@linaro.org, JBottomley@parallels.com,
        megaraidlinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org> <1336774168-26577-7-git-send-email-mathieu.poirier@linaro.org> <CAHtARFFnLrk0zQ7GeoiPX3Cyso9zq-05q+RyyeGN0v7q=Dm1gQ@mail.gmail.com>
In-Reply-To: <CAHtARFFnLrk0zQ7GeoiPX3Cyso9zq-05q+RyyeGN0v7q=Dm1gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205121302.21623.arnd@arndb.de>
X-Provags-ID: V02:K0:JJxlQmHPHieaf58eXEUR/PMZuVEW4ETKvuwDpjts5ri
 MB3u9fnXDdtLQNYNmhPiE2oXKYf9XsbrB43/VLrNsaG0vuj2zH
 RfSPKdJE29cNq+lGDC8UsGjbEzg1vbL4jQkuhlmGfk3KasJsF5
 lB0WQEETkMBN7pnwSivvEkjSOhZZxh1XlvuLJACKdJkCyXIW10
 HfPnLNzlOofTeRwta+dhOgQ9CtYkdC1Rj3ZftFfWa7O8vGZaNj
 D/oExiTTHPA+FvFVKa9YC4U3XdXmC2mz0OjBGW1/saOqDY970l
 Yhmue8+liKnteQjQBCq6npiJytrM6DeRA8ebI4M1zh6xCXxgWu
 PUmBNNtP5j+iQsdrzVh0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 May 2012, adam radford wrote:
> 
> On Fri, May 11, 2012 at 3:09 PM,  <mathieu.poirier@linaro.org> wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> ...
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > index bfd87fa..234ad74 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > @@ -51,55 +51,16 @@
> >  #include <scsi/scsi_device.h>
> >  #include <scsi/scsi_host.h>
> >
> > +#include "mega_common.h"
> 
> Do not include mega_common.h in the megaraid_sas driver.  It has
> nothing to do with this driver.  It is for the older Parallel SCSI
> megaraid drivers.

Ok. I think I first tried moving all declarations into mega_common.h
and then decided otherwise but forgot to remove that #include statement
again. Thanks for taking a look!

	Arnd
