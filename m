Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0JAVJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 17:09:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36392 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab0JAVJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:09:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [git pull request] ACPI patches for Linux 2.6.36-rc6
Date: Fri, 1 Oct 2010 23:08:12 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, stable@kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <alpine.LFD.2.00.1010010142470.7033@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1010010142470.7033@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201010012308.12897.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 01, 2010, Len Brown wrote:
> Hi Linus,
> 
> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> 
...
> commit 573b638158029898caf9470c8214b7ddd29751e3
> Author: Colin Ian King <colin.king@canonical.com>
> Date:   Mon Aug 2 15:14:43 2010 +0000

This one should go to -stable, shouldn't it?

>     ACPI: enable repeated PCIEXP wakeup by clearing PCIEXP_WAKE_STS on resume
>     
>     Section 4.7.3.1.1 (PM1 Status Registers) of version 4.0 of
>     the ACPI spec concerning PCIEXP_WAKE_STS points out in
>     in the final note field in table 4-11 that if this bit is
>     set to 1 and the system is put into a sleeping state then
>     the system will not automatically wake.
>     
>     This bit gets set by hardware to indicate that the system
>     woke up due to a PCI Express wakeup event, so clear it during
>     acpi_hw_clear_acpi_status() calls to enable subsequent
>     resumes to work.
>     
>     BugLink: http://bugs.launchpad.net/bugs/613381
>     
>     Signed-off-by: Colin Ian King <colin.king@canonical.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>

Thanks,
Rafael
