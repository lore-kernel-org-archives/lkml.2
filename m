Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1DZAp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:45:26 -0400
Received: from kroah.org ([198.145.64.141]:39976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab1DZApY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:45:24 -0400
Date: Mon, 25 Apr 2011 17:41:16 -0700
From: Greg KH <greg@kroah.com>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: "Allyn, Mark A" <mark.a.allyn@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Subject: Re: [PATCH 1/1] staging: sep: move to misc: sep: to move to mainline
Message-ID: <20110426004116.GB29534@kroah.com>
References: <1303505449-25111-1-git-send-email-mark.a.allyn@intel.com>
 <4F65016F6CB04E49BFFA15D4F7B798D901B703E89F@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D901B703E89F@orsmsx506.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 01:56:23PM -0700, Cihula, Joseph wrote:
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of
> > Mark Allyn
> > Sent: Friday, April 22, 2011 1:51 PM
> >
> > Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>

Nope, not yet, see my other comments about this driver.

thanks,

greg k-h


> > ---
> >  drivers/misc/Kconfig                     |    1 +
> >  drivers/misc/Makefile                    |    1 +
> >  drivers/misc/sep/Kconfig                 |   10 +
> >  drivers/misc/sep/Makefile                |    2 +
> >  drivers/misc/sep/TODO                    |    4 +
> >  drivers/misc/sep/sep_dev.h               |  131 ++
> >  drivers/misc/sep/sep_driver.c            | 2928 ++++++++++++++++++++++++++++++
> >  drivers/misc/sep/sep_driver_api.h        |  215 +++
> >  drivers/misc/sep/sep_driver_config.h     |  243 +++
> >  drivers/misc/sep/sep_driver_hw_defs.h    |  233 +++
> >  drivers/staging/Kconfig                  |    2 -
> >  drivers/staging/Makefile                 |    1 -
> >  drivers/staging/sep/Kconfig              |   10 -
> >  drivers/staging/sep/Makefile             |    2 -
> >  drivers/staging/sep/TODO                 |    4 -
> >  drivers/staging/sep/sep_dev.h            |  131 --
> >  drivers/staging/sep/sep_driver.c         | 2928 ------------------------------
> >  drivers/staging/sep/sep_driver_api.h     |  215 ---
> >  drivers/staging/sep/sep_driver_config.h  |  243 ---
> >  drivers/staging/sep/sep_driver_hw_defs.h |  233 ---
> >  20 files changed, 3768 insertions(+), 3769 deletions(-)
> >  create mode 100644 drivers/misc/sep/Kconfig
> >  create mode 100644 drivers/misc/sep/Makefile
> >  create mode 100644 drivers/misc/sep/TODO
> >  create mode 100644 drivers/misc/sep/sep_dev.h
> >  create mode 100644 drivers/misc/sep/sep_driver.c
> >  create mode 100644 drivers/misc/sep/sep_driver_api.h
> >  create mode 100644 drivers/misc/sep/sep_driver_config.h
> >  create mode 100644 drivers/misc/sep/sep_driver_hw_defs.h
> >  delete mode 100644 drivers/staging/sep/Kconfig
> >  delete mode 100644 drivers/staging/sep/Makefile
> >  delete mode 100644 drivers/staging/sep/TODO
> >  delete mode 100644 drivers/staging/sep/sep_dev.h
> >  delete mode 100644 drivers/staging/sep/sep_driver.c
> >  delete mode 100644 drivers/staging/sep/sep_driver_api.h
> >  delete mode 100644 drivers/staging/sep/sep_driver_config.h
> >  delete mode 100644 drivers/staging/sep/sep_driver_hw_defs.h

Next time you do this, do so using git so we can be sure that you really
did just move the files and nothing changed.  I can handle patches
generated that way (i.e. renames).

thanks,

greg k-h
