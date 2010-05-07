Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab0EGSvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:51:10 -0400
Received: from mail.perches.com ([173.55.12.10]:1970 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab0EGSvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:51:08 -0400
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
From: Joe Perches <joe@perches.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 11:51:06 -0700
Message-ID: <1273258266.1540.63.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 10:41 -0700, Jacob Pan wrote: 
> +	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
> +	"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
> +

Even though many of the rtc drivers print this way, it seems
a very backwards way of presenting time to me.

I think "yyyy-mm-dd hh:mm:ss" is a better representation, more
compact and readable.

Also KERN_INFO may not be good, maybe KERN_DEBUG or pr_debug?

