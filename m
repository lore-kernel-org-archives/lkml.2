Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1LBH2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 02:28:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36364 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1LBH2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 02:28:05 -0500
Date: Fri, 2 Dec 2011 11:28:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 1/3] fs, proc: Add start_data, end_data, start_brk members
 to /proc/$pid/stat
Message-ID: <20111202072800.GC14515@moon>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.756761754@openvz.org>
 <20111129200627.GO5169@outflux.net>
 <20111202002405.GA7701@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202002405.GA7701@p183.telecom.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 03:24:06AM +0300, Alexey Dobriyan wrote:
> > > +		cputime_to_clock_t(cgtime),
> > > +		mm ? (permitted ? mm->start_data : 1) : 0,
> > > +		mm ? (permitted ? mm->end_data : 1) : 0,
> > > +		mm ? (permitted ? mm->start_brk : 1) : 0);
> > >  	if (mm)
> > >  		mmput(mm);
> > >  	return 0;
> > 
> > Thanks for using "permitted" here. :)
> 
> And these are new fields, so "1" hack is unnecessary.
> 

I perhaps miss some history here, you mean just print 0
instead of 1, right?

	Cyrill
