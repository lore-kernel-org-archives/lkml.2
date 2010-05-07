Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab0EGS4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:56:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50444 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751080Ab0EGS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:56:35 -0400
Date: Fri, 7 May 2010 20:02:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
Message-ID: <20100507200208.09b2941d@lxorguk.ukuu.org.uk>
In-Reply-To: <1273258266.1540.63.camel@Joe-Laptop.home>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273258266.1540.63.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 May 2010 11:51:06 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2010-05-07 at 10:41 -0700, Jacob Pan wrote: 
> > +	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
> > +	"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
> > +
> 
> Even though many of the rtc drivers print this way, it seems
> a very backwards way of presenting time to me.

Consistency is really more important here IMHO - lots of drivers have set
an existing policy.

