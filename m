Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1E3HGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:06:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:1788 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab1E3HGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,290,1304319600"; 
   d="scan'208";a="3840065"
Subject: Re: [PATCH 2/3] introduce intel_rapl driver
From: Zhang Rui <rui.zhang@intel.com>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>, "acme@redhat.com" <acme@redhat.com>,
        "Lin, Ming M" <ming.m.lin@intel.com>, "Brown, Len" <lenb@kernel.org>
In-Reply-To: <20110528101757.GA32493@kroah.com>
References: <1306398857.2207.157.camel@rui>
	 <20110528101757.GA32493@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 15:04:20 +0800
Message-ID: <1306739060.32738.245.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Greg,

On Sat, 2011-05-28 at 18:17 +0800, Greg KH wrote:
> On Thu, May 26, 2011 at 04:34:17PM +0800, Zhang Rui wrote:
> > +/*
> > + *  Intel RAPL interface driver
> > + *
> > + *  Copyright (C) 2010-2011 Zhang Rui <rui.zhang@intel.com>
> > + *
> > + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > + *
> > + *  This program is free software; you can redistribute it and/or modify
> > + *  it under the terms of the GNU General Public License as published by
> > + *  the Free Software Foundation; either version 2 of the License, or (at
> > + *  your option) any later version.
> 
> Are you really sure about "any later version"?  I didn't think that was
> the default rule of Intel kernel code these days, have you verified this
> exception is ok?
> 
Sorry, I overlooked this problem and just did the copy & paste from
another driver. It won't happen again.

thanks,
rui

> > + *
> > + *  This program is distributed in the hope that it will be useful, but
> > + *  WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > + *  General Public License for more details.
> > + *
> > + *  You should have received a copy of the GNU General Public License along
> > + *  with this program; if not, write to the Free Software Foundation, Inc.,
> > + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> 
> These two paragraphs are not needed, and the last one is never needed
> unless you want to track the office movements of the FSF for the next
> 50+ years and always update this file because of that.
> 
> greg k-h


