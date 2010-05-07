Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab0EGTGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:06:31 -0400
Received: from mail.perches.com ([173.55.12.10]:1980 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab0EGTG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:06:29 -0400
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alessandro Zummo <a.zummo@towertech.it>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100507200208.09b2941d@lxorguk.ukuu.org.uk>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1273258266.1540.63.camel@Joe-Laptop.home>
	 <20100507200208.09b2941d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 12:06:27 -0700
Message-ID: <1273259187.1540.75.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 20:02 +0100, Alan Cox wrote:
> On Fri, 07 May 2010 11:51:06 -0700
> Joe Perches <joe@perches.com> wrote:
> > On Fri, 2010-05-07 at 10:41 -0700, Jacob Pan wrote: 
> > > +	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
> > > +	"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
> > Even though many of the rtc drivers print this way, it seems
> > a very backwards way of presenting time to me.
> Consistency is really more important here IMHO - lots of drivers have set
> an existing policy.

(added Alessandro Zummo to cc's)

look at drivers/rtc.

All of them seem to use a templated copy/paste dev_dbg,
which seems to point to a use for a possible common rtc_util.c
or some such where this could be standardized.
 
Is there somewhere else this style is used?

