Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab2JaD3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 23:29:16 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58568 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab2JaD3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 23:29:14 -0400
Date: Tue, 30 Oct 2012 23:29:02 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 1/9] random32: introduce random32_get_bytes() and
 prandom32_get_bytes()
Message-ID: <20121031032902.GD9475@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Artem Bityutskiy <dedekind1@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-mtd@lists.infradead.org
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
 <20121029203937.GC7098@thunk.org>
 <CAC5umyhje4oDtKzw6kYSXw99rVzZJOaeApfizGeDos3SnmUcjA@mail.gmail.com>
 <CAC5umyi=f+Q2Dxc4KS8nKd8uD3yvVNf8M9g1-nBt+6UsqSGHdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC5umyi=f+Q2Dxc4KS8nKd8uD3yvVNf8M9g1-nBt+6UsqSGHdg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 08:12:39PM +0900, Akinobu Mita wrote:
> >>
> >> How about prandom32_get_bytes_state() and prandom32_get_bytes() instead?
> >
> > I agree with your suggestion.  I'll rename them and try again.
> >
> > By the way, should we also rename the existing random32() and
> > prandom32() in the future?

I suppose the other way to go is to just use random32 as the common
prefix, and just have random32() and random32_state().  My concern was
that people might assume that prandom32() and random32() might imply
that only prandom32() was the one using a pseudo-random number
generator.  This might be easier since there are large number of uses
of random32() in the source tree, but only a relative few using
prandom32().

    	   	     	    	     - Ted
