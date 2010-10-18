Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab0JRXId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:08:33 -0400
Received: from nm10.bullet.mail.ne1.yahoo.com ([98.138.90.73]:26347 "HELO
	nm10.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755487Ab0JRXIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:08:31 -0400
X-Yahoo-Newman-Id: 722776.10004.bm@omp1014.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: TA9l8lkVM1mt.4SkPTAd8b6xYyobwLWK44bUNsttJp6wwLS
 euCyXS4OATd0DV2w3Q4TX1WRoDpenEMEWVubG6pfI_WVz5hxy2NaUbwutky.
 cr.ye_4hbnpNvjNRT7gj5hGielOyrHiAyHtaIO_82S5gh69FFzWZ7T4DN9iy
 WcxnJcKX_IaV5qFpt0RbJ9rUeoQIxy4a6LBzXWXYYwXy0rffqeGi9e9ejuWp
 NQ8vTPIdXdYcJfMQdHyHg5vBD_jtYKs5R8H1mUpsoQMRuHWCIBFk5ikBisr7
 YsVAkMz0bSeebk3K9miJH61Va1KxfZfQt0.WhZIGFvh7EcDYWH13.R2AXAf6
 75.LVgz.qkkD7ZW4ks0k-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFCv3 20/21] tcm: Add Kbuild and Kconfig for drivers/target
	and Documentation/target/
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20101018154859.66b71121.randy.dunlap@oracle.com>
References: <1287441559-20129-1-git-send-email-nab@linux-iscsi.org>
	 <20101018154859.66b71121.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 18 Oct 2010 16:03:42 -0700
Message-Id: <1287443022.14039.198.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 15:48 -0700, Randy Dunlap wrote:
> On Mon, 18 Oct 2010 15:39:19 -0700 Nicholas A. Bellinger wrote:
> 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Add TCM Kbuild and Kconfig files and update drivers/ to pick up drivers/target.
> > Add Docmentation/target/ for tcm_mod_builder.py script for generating new
> > TCM v4 fabric modules functional ConfigFS skeletons.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  Documentation/target/tcm_mod_builder.py  | 1094 ++++++++++++++++++++++++++++++
> >  Documentation/target/tcm_mod_builder.txt |  145 ++++
> >  drivers/Kconfig                          |    2 +
> >  drivers/Makefile                         |    1 +
> >  drivers/target/Kbuild                    |   27 +
> >  drivers/target/Kconfig                   |   34 +
> >  6 files changed, 1303 insertions(+), 0 deletions(-)
> >  create mode 100755 Documentation/target/tcm_mod_builder.py
> >  create mode 100644 Documentation/target/tcm_mod_builder.txt
> >  create mode 100644 drivers/target/Kbuild
> >  create mode 100644 drivers/target/Kconfig
> 
> 
> > diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
> > new file mode 100644
> > index 0000000..5c37653
> > --- /dev/null
> > +++ b/drivers/target/Kconfig
> > @@ -0,0 +1,34 @@
> > +config TARGET_CORE
> > +        tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
> > +	select CONFIGFS_FS
> 
> Indentation: use tabs, not spaces.
> 

Whoops, fixed.  Thanks for spotting this..

> > +        default m
> 
> Don't enable random drivers/modules.
> Let the user or defconfig do that.

Understood, changing to 'default n'.

Thanks!

--nab

