Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0EJRVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:21:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64768 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab0EJRVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:21:46 -0400
Message-ID: <4BE84039.6000703@oracle.com>
Date: Mon, 10 May 2010 10:19:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Alexander Kurz <linux@blala.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers grouped
 by bustype.
References: <alpine.DEB.1.10.1005081218220.5727@blala.de>
In-Reply-To: <alpine.DEB.1.10.1005081218220.5727@blala.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090204.4BE8408E.017A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/10 01:21, Alexander Kurz wrote:
> This is a new Kconfig and Makefikes for staging/comedi.
> The drivers are sorted now alphabetically in sub-menus
> depending on the bustype.
> I did some basiy dependancy tests, but there still may
> be a lot that I missed.
> 
> From c53596606230a4a8ee7dd76b48cf6b10a059e8f7 Mon Sep 17 00:00:00 2001
> From: Alexander Kurz <linux@kbdbabel.org>
> Date: Fri, 7 May 2010 22:46:17 +0200
> Subject: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers grouped by bustype.
>  PC/104-drivers went into ISA,
>  PC/104+ went into PCI,
>  Drivers without a bustype went into "misc".
>  In doubt drivers supporting both ISA/PCI went into PCI.
>  Drivers without any detailed hardware info went into ISA, e.g. fl512.c
>  Some NI drivers are used by other NI drivers from different bustypes
>  are grouped seperately in NI_COMMON.

Hi,

I didn't review the patch in detail (I'm surprised to see such a large Kconfig
file patch), it does seem to do what is needed to prevent build errors that I was
seeing, but it needs more testing time...

Thanks.

> Signed-off-by: Alexander Kurz <linux@kbdbabel.org>
> ---
>  drivers/staging/comedi/Kconfig             | 1274 +++++++++++++++++++++++++++-
>  drivers/staging/comedi/drivers/Makefile    |  245 +++---
>  drivers/staging/comedi/kcomedilib/Makefile |    2 +-
>  3 files changed, 1392 insertions(+), 129 deletions(-)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
