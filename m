Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab2GXPmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 11:42:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59439 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab2GXPmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 11:42:21 -0400
Date: Tue, 24 Jul 2012 17:42:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120724154218.GB13753@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	=?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
	Steve Hodgson <steve@purestorage.com>
References: <x49zka0j5bk.fsf@segfault.boston.devel.redhat.com>
 <20120425132513.GA23492@logfs.org>
 <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com>
 <20120712174633.GA7248@logfs.org>
 <20120713130336.GC10298@x1.osrc.amd.com>
 <20120713162009.GA10268@logfs.org>
 <20120716124614.GA19497@x1.osrc.amd.com>
 <20120718185335.GA1771@logfs.org>
 <20120718214520.GA14067@liondog.tnic>
 <20120723200459.GD17767@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120723200459.GD17767@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 04:04:59PM -0400, Jörn Engel wrote:
> On Wed, 18 July 2012 23:45:21 +0200, Borislav Petkov wrote:
> > 
> > Something like the above, just slap it at the beginning of
> > Documentation/block/blockconsole.txt for impatient people like me and
> > that's it :-).
> 
> And below is an updated patch with your changes folded in.  I did a
> few minor tweaks, so there is every possibility I may have messed it
> up.

Ok, everything seems to build and boot fine, logging works too.

Just a minor nuisance: I have this in the log:

...
[   10.498422] console [bcon0] enabled
[   10.499899] blockconsole: now logging to /dev/sdc at 1
[   10.594791] usb 5-2: new full-speed USB device number 3 using ohci_hcd
                                                                                                                                
[   12.665911] xhci_hcd 0000:00:10.0: xHCI Host Controller
[   12.668469] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 6
...

which doesn't have the empty line with a bunch of '\s' chars:

...
[   10.498422] console [bcon0] enabled
[   10.499899] blockconsole: now logging to /dev/sdc at 1
[   10.594791] usb 5-2: new full-speed USB device number 3 using ohci_hcd
[   12.665911] xhci_hcd 0000:00:10.0: xHCI Host Controller
[   12.668469] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 6
...

Do you know per-chance why that happens? I have a couple more lines like
that further in the log file which bcon_tail generated.

Thanks.

-- 
Regards/Gruss,
Boris.
