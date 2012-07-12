Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab2GLJA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 05:00:27 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62524 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826Ab2GLJAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 05:00:23 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Randy Dunlap'" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-next@vger.kernel.org, "'Mike Lockwood'" <lockwood@android.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <20120711000148.BAD1E5C0050@hpza9.eem.corp.google.com>
 <4FFDF7BC.6050602@xenotime.net>
 <20120711151644.23016bd8.akpm@linux-foundation.org>
In-reply-to: <20120711151644.23016bd8.akpm@linux-foundation.org>
Subject: RE: mmotm 2012-07-10-16-59 uploaded (staging/ccg)
Date: Thu, 12 Jul 2012 11:00:13 +0200
Message-id: <000001cd600c$c00e0230$402a0690$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1fst2V6qx3VUx2SliT+bw+Cv+EEwAUo8Jg
Content-language: pl
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew,

On Thursday, July 12, 2012 12:17 AM Andrew Morton wrote:

> On Wed, 11 Jul 2012 15:01:32 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > In file included from drivers/staging/ccg/ccg.c:59:0:
> > drivers/staging/ccg/../../usb/gadget/f_fs.c:41:0: warning: "pr_vdebug"
> redefined
> > drivers/staging/ccg/../../usb/gadget/u_serial.c:138:0: note: this is the
> location of the previous definition
> 
> <looks at drivers/staging/ccg/ccg.c>

<snip>

@Randy:

There is a patch for this:
http://www.spinics.net/lists/linux-usb/msg65344.html

I guess you acked it.

@Feilpe, Greg:

Should I send a pull request?

> 
> : /*
> :  * Kbuild is not very cooperative with respect to linking separately
> :  * compiled library objects into one module.  So for now we won't use
> :  * separate compilation ... ensuring init/exit sections work to shrink
> :  * the runtime footprint, and giving us at least some parts of what
> :  * a "gcc --combine ... part1.c part2.c part3.c ... " build would.
> :  */

<snip>

> Who wrote that

<snip>

> comment?  

<snip>

FYI: The text was taken from Gadget Zero (zero.c) and was originally
written by David Brownell, may he Rest in Peace.

I think that the #include approach is intended to be revised sometime:
http://marc.info/?l=linux-usb&m=132431126927355&w=2 - if there is
just one gadget module configurable through configfs, the things will
probably be simplified.

AP


