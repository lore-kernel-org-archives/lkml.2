Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1FCPSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:18:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab1FCPSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:18:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor management driver
Date: Fri, 3 Jun 2011 17:17:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: kumar.gala@freescale.com, benh@kernel.crashing.org, greg@kroah.com,
        akpm@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106012340.14237.arnd@arndb.de> <4DE8F347.9060104@freescale.com>
In-Reply-To: <4DE8F347.9060104@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106031717.59927.arnd@arndb.de>
X-Provags-ID: V02:K0:QwaY3NrpXnbtkfUtko1kQOpRIJSe5vYY+td1PkevYsD
 M94+TwkOZkKoWr9QQ85anW7Euig61cVGod32fWZcdOcPBoxlLQ
 QH7lbVmYnWqikPXSlLVdGQbcgiTEA6NvBlYB/63bQOQ8dYYVsP
 GB+jxxq8F8abPAZUUjRKGO2vNFnchjkxTsd48xmBsxUwKDt7RT
 ouTe/EgTqPT57spy8D4ng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011, Timur Tabi wrote:
> Arnd Bergmann wrote:
> > For an ioctl, please follow the normal pattern of defining a separate
> > structure for each case, no union.
> > 
> > You can use a void __user * in the common ioctl function, and pass that
> > to the typed argument list in the specific functions.
> 
> I have a GPL question.  This header file is currently licensed under the  GPL v2
> only.  Does that mean that any application that includes this header file so
> that it can talk to the driver/hypervisor also needs to be licensed under the GPL?

If you have a license question, ask your lawyer.

Common answers that you would hear are:

* User space interfaces of the kernel are excluded from the License by the
  "normal system call" exception in linux/COPYING.

* If the header files only contain interfaces but no code, they are not
  copyrighted.

* If you want to ship a copy of the file with a user space application source,
  but have to make it available under multiple licenses to do that, e.g. dual
  GPL/BSD.

	Arnd
