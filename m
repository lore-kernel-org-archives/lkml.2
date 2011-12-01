Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1LADqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:46:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab1LADqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:46:12 -0500
Date: Wed, 30 Nov 2011 19:21:13 -0800
From: Greg KH <gregkh@suse.de>
To: Mike Waychison <mikew@google.com>
Cc: "Maxin B. John" <maxin.john@gmail.com>, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, dlaurie@google.com, adurbin@google.com
Subject: Re: [PATCH] firmware: google: fix gsmi.c build warning
Message-ID: <20111201032113.GA6917@suse.de>
References: <20111130233733.GA11577@maxin>
 <CAGTjWtCy_syX18y23mUD7HZJe3fdjUDCY7YDMwKesFFjd4VwZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGTjWtCy_syX18y23mUD7HZJe3fdjUDCY7YDMwKesFFjd4VwZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 03:56:25PM -0800, Mike Waychison wrote:
> On Wed, Nov 30, 2011 at 3:37 PM, Maxin B. John <maxin.john@gmail.com> wrote:
> > Use min_t() macro instead of min() to fix a build warning:
> >
> 
> Looks good.  Greg, could you please pull this into your drivers tree?

Yes I will if you ack it :)

greg k-h
