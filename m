Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956Ab1AVTNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 14:13:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42390 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab1AVTNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 14:13:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH 0/11] ACPI: Fixes and cleanups related to iomaps management
Date: Sat, 22 Jan 2011 20:12:13 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201101201226.41021.rjw@sisk.pl> <201101221025.49327.rjw@sisk.pl> <AANLkTi=MDyaPj9D+28NWRRK13qhJfKw098xPPhwrGZoa@mail.gmail.com>
In-Reply-To: <AANLkTi=MDyaPj9D+28NWRRK13qhJfKw098xPPhwrGZoa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101222012.14028.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 22, 2011, Jeff Chua wrote:
> 2011/1/22 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Saturday, January 22, 2011, Jeff Chua wrote:
> 
> > means that my patch [11/11] _and_ the replacement are totally wrong, because you have
> > _multiple_ NVS regions.  That really helped, thanks a lot.
> 
> Would it be different if I offline all CPUs before suspending to ram?
> It seems to help with suspending to disk.

No, that doesn't matter.  NVS regions are just sitting there regardless of
what happens at run time.

Thanks,
Rafael
