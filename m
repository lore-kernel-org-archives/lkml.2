Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab0EGQTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:19:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38620 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab0EGQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:19:10 -0400
Date: Fri, 7 May 2010 09:18:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [RFC PATCHv2 1/7] HSI: Introducing HSI framework
Message-Id: <20100507091808.d294050a.randy.dunlap@oracle.com>
In-Reply-To: <1273248713.7755.7261.camel@localhost>
References: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com>
	<1273245517-30712-2-git-send-email-carlos.chinea@nokia.com>
	<20100507082629.3bdf0b17.randy.dunlap@oracle.com>
	<1273248713.7755.7261.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BE43D78.01FB:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 May 2010 19:11:53 +0300 Carlos Chinea wrote:

> Hi,
> 
> On Fri, 2010-05-07 at 17:26 +0200, ext Randy Dunlap wrote:
> > On Fri,  7 May 2010 18:18:31 +0300 Carlos Chinea wrote:
> > 
> --[snip]--
> 
> > > diff --git a/drivers/hsi/Kconfig b/drivers/hsi/Kconfig
> > > new file mode 100644
> > > index 0000000..5af62ce
> > > --- /dev/null
> > > +++ b/drivers/hsi/Kconfig
> > > @@ -0,0 +1,13 @@
> > > +#
> > > +# HSI driver configuration
> > > +#
> > > +menuconfig HSI
> > > +	bool "HSI support"
> > 
> > Why is this bool instead of tristate?
> > IOW, why can it not be built as a loadable module?
> > 
> 
> Because, I have not implemented it yet. I was planning to do it later
> on. But of course if it has to be there, I can add the module support
> now.

OK, it can wait, no hurry.

Thanks.

> > 
> > > +	---help---
> > > +	  The "High speed synchronous Serial Interface" is
> > > +	  synchronous serial interface used mainly to connect
> > > +	  application engines and cellular modems.
> > > +
> > > +if HSI
> > > +
> > > +endif # HSI
> > > diff --git a/drivers/hsi/Makefile b/drivers/hsi/Makefile
> > > new file mode 100644
> > > index 0000000..b42b6cf
> > > --- /dev/null
> > > +++ b/drivers/hsi/Makefile
> > > @@ -0,0 +1,4 @@
> > > +#
> > > +# Makefile for HSI
> > > +#
> > > +obj-$(CONFIG_HSI)	+= hsi.o
> > 
> > 
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> Br,
> Carlos
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
