Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab1LGRWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:22:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab1LGRWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:22:14 -0500
Date: Wed, 7 Dec 2011 09:16:46 -0800
From: Greg KH <gregkh@suse.de>
To: Maxin B John <maxin.john@gmail.com>
Cc: Mike Waychison <mikew@google.com>, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, dlaurie@google.com, adurbin@google.com
Subject: Re: [PATCH] firmware: google: fix gsmi.c build warning
Message-ID: <20111207171646.GA21136@suse.de>
References: <20111130233733.GA11577@maxin>
 <CAGTjWtCy_syX18y23mUD7HZJe3fdjUDCY7YDMwKesFFjd4VwZQ@mail.gmail.com>
 <20111201032113.GA6917@suse.de>
 <CAGTjWtC2Toqd8H1Z9pHky7nJguOyedUoypU5zrWvi8X+v4cD3Q@mail.gmail.com>
 <CAMhs6YzEvAQnq=HPWfWWcsQ1b=Jgc1u1R=u1y6US_1anVntAgQ@mail.gmail.com>
 <CAMhs6YwHyAG8tU7+igZutKdQMHg+Qa4K73rcjY=9Fu0mDg_BWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMhs6YwHyAG8tU7+igZutKdQMHg+Qa4K73rcjY=9Fu0mDg_BWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 01:55:30PM +0200, Maxin B John wrote:
> On Thu, Dec 1, 2011 at 4:29 PM, Maxin B John <maxin.john@gmail.com> wrote:
> > On Thu, Dec 1, 2011 at 8:07 AM, Mike Waychison <mikew@google.com> wrote:
> >> On Wed, Nov 30, 2011 at 7:21 PM, Greg KH <gregkh@suse.de> wrote:
> >>> On Wed, Nov 30, 2011 at 03:56:25PM -0800, Mike Waychison wrote:
> >>>> On Wed, Nov 30, 2011 at 3:37 PM, Maxin B. John <maxin.john@gmail.com> wrote:
> >>>> > Use min_t() macro instead of min() to fix a build warning:
> >>>> >
> >>>>
> >>>> Looks good.  Greg, could you please pull this into your drivers tree?
> >>>
> >>> Yes I will if you ack it :)
> >>
> >> Acked-By: Mike Waychison <mikew@google.com>
> 
> Greg,  Ping ..

It's in my queue, patience please.

greg k-h
