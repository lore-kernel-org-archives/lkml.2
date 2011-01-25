Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1AYLDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:03:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab1AYLDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:03:35 -0500
Date: Tue, 25 Jan 2011 12:03:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Joey Lee <jlee@novell.com>
Cc: jj@chaosbits.net, mjg@redhat.com, carlos@strangeworlds.co.uk,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] X86, Acer, WMI: Do not double include linux/dmi.h in
 acer-wmi.c
In-Reply-To: <4D3EC34A020000230002799D@novprvlin0050.provo.novell.com>
Message-ID: <alpine.LNX.2.00.1101251203260.5725@pobox.suse.cz>
References: <4D3EC34A020000230002799D@novprvlin0050.provo.novell.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011, Joey Lee wrote:

> Hi Jesper, 
> 
> 於 一，2011-01-24 於 22:12 +0100，Jesper Juhl 提到：
> > Including linux/dmi.h once in drivers/platform/x86/acer-wmi.c is enough.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  acer-wmi.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> > index c5c4b8c..f21eb53 100644
> > --- a/drivers/platform/x86/acer-wmi.c
> > +++ b/drivers/platform/x86/acer-wmi.c
> > @@ -39,7 +39,6 @@
> >  #include <linux/slab.h>
> >  #include <linux/input.h>
> >  #include <linux/input/sparse-keymap.h>
> > -#include <linux/dmi.h>
> >  
> >  #include <acpi/acpi_drivers.h>
> >  
> > 
> 
> Reviewed-by: Lee, Chun-Yi <jlee@novell.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
