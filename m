Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0EGQKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:10:00 -0400
Received: from smtp.nokia.com ([192.100.105.134]:31795 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0EGQJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:09:58 -0400
Subject: Re: [RFC PATCHv2 1/7] HSI: Introducing HSI framework
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Randy Dunlap <randy.dunlap@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
In-Reply-To: <20100507082629.3bdf0b17.randy.dunlap@oracle.com>
References: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com>
	 <1273245517-30712-2-git-send-email-carlos.chinea@nokia.com>
	 <20100507082629.3bdf0b17.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Fri, 07 May 2010 19:11:53 +0300
Message-Id: <1273248713.7755.7261.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2010 16:08:59.0682 (UTC) FILETIME=[9A6DF020:01CAEDFF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2010-05-07 at 17:26 +0200, ext Randy Dunlap wrote:
> On Fri,  7 May 2010 18:18:31 +0300 Carlos Chinea wrote:
> 
--[snip]--

> > diff --git a/drivers/hsi/Kconfig b/drivers/hsi/Kconfig
> > new file mode 100644
> > index 0000000..5af62ce
> > --- /dev/null
> > +++ b/drivers/hsi/Kconfig
> > @@ -0,0 +1,13 @@
> > +#
> > +# HSI driver configuration
> > +#
> > +menuconfig HSI
> > +	bool "HSI support"
> 
> Why is this bool instead of tristate?
> IOW, why can it not be built as a loadable module?
> 

Because, I have not implemented it yet. I was planning to do it later
on. But of course if it has to be there, I can add the module support
now.

> 
> > +	---help---
> > +	  The "High speed synchronous Serial Interface" is
> > +	  synchronous serial interface used mainly to connect
> > +	  application engines and cellular modems.
> > +
> > +if HSI
> > +
> > +endif # HSI
> > diff --git a/drivers/hsi/Makefile b/drivers/hsi/Makefile
> > new file mode 100644
> > index 0000000..b42b6cf
> > --- /dev/null
> > +++ b/drivers/hsi/Makefile
> > @@ -0,0 +1,4 @@
> > +#
> > +# Makefile for HSI
> > +#
> > +obj-$(CONFIG_HSI)	+= hsi.o
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

Br,
Carlos


