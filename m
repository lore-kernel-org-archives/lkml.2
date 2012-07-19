Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2GSJ0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:26:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52502 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab2GSJ0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:26:14 -0400
Date: Thu, 19 Jul 2012 11:26:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120719092608.GA24872@liondog.tnic>
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
 <20120718210814.GA1871@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120718210814.GA1871@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 05:08:15PM -0400, Jörn Engel wrote:
> On Wed, 18 July 2012 23:45:21 +0200, Borislav Petkov wrote:
> > 
> > > > So why is that first megabyte full of zeros there?
> > > 
> > > It gives you some scratch space to store information in.
> > 
> > How? By me writing something in that empty line in vim? Or something
> > else storing stuff there?
> 
> Assuming you want to do it in an automated fashion - by patching or
> replacing mkblockconsole.  Again, I have no opinion on whether this
> actually makes sense.  It is possible, it does not really hurt the
> primary function and people have explicitly asked me for it.  Good
> enough for me.

I see. It would be interesting to know what the use cases of those
people are. In any case, this is not an interface since you only have
one-way data movement from kernel to userspace and you can change the
formatting/layout of that data later with no obvious issues, AFAICT.

[ … ]

> Or show off your geekiness by using back ticks:
> $ vi `./bcon_tail`

Uuh, magic. Definitely! :-)

Thanks.

-- 
Regards/Gruss,
    Boris.
