Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024Ab2GLPXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:23:49 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56863 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab2GLPXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:23:47 -0400
Date: Thu, 12 Jul 2012 08:23:40 -0700
From: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Randy Dunlap'" <rdunlap@xenotime.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, "'Felipe Balbi'" <balbi@ti.com>,
        linux-next@vger.kernel.org, "'Mike Lockwood'" <lockwood@android.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: mmotm 2012-07-10-16-59 uploaded (staging/ccg)
Message-ID: <20120712152340.GA17263@kroah.com>
References: <20120711000148.BAD1E5C0050@hpza9.eem.corp.google.com>
 <4FFDF7BC.6050602@xenotime.net>
 <20120711151644.23016bd8.akpm@linux-foundation.org>
 <000001cd600c$c00e0230$402a0690$%p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cd600c$c00e0230$402a0690$%p@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 11:00:13AM +0200, Andrzej Pietrasiewicz wrote:
> Dear Andrew,
> 
> On Thursday, July 12, 2012 12:17 AM Andrew Morton wrote:
> 
> > On Wed, 11 Jul 2012 15:01:32 -0700
> > Randy Dunlap <rdunlap@xenotime.net> wrote:
> > 
> > > In file included from drivers/staging/ccg/ccg.c:59:0:
> > > drivers/staging/ccg/../../usb/gadget/f_fs.c:41:0: warning: "pr_vdebug"
> > redefined
> > > drivers/staging/ccg/../../usb/gadget/u_serial.c:138:0: note: this is the
> > location of the previous definition
> > 
> > <looks at drivers/staging/ccg/ccg.c>
> 
> <snip>
> 
> @Randy:
> 
> There is a patch for this:
> http://www.spinics.net/lists/linux-usb/msg65344.html
> 
> I guess you acked it.
> 
> @Feilpe, Greg:
> 
> Should I send a pull request?

Felipe is on vacation until next week, he should be handling this patch
then.

thanks,

greg k-h
