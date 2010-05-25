Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258Ab0EYUvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:51:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759060Ab0EYUvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:51:39 -0400
Date: Tue, 25 May 2010 13:50:20 -0700
From: Greg KH <gregkh@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Frank Arnold <frank.arnold@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>
Subject: Re: [28/39] x86, cacheinfo: Turn off L3 cache index disable
 feature in virtualized environments
Message-ID: <20100525205020.GA14945@suse.de>
References: <20100524231840.GA17857@kroah.com>
 <20100524231815.713224572@clark.site>
 <AANLkTilMq6zUgCus6_suEjAcTPYY7Ao0gCvrWHkTe9F6@mail.gmail.com>
 <20100525171411.GA3548@suse.de>
 <AANLkTilJxUz_24qlnXdpKOTBzDTDAy2Q628UmFplXkML@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilJxUz_24qlnXdpKOTBzDTDAy2Q628UmFplXkML@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 01:41:37PM -0700, Hugh Dickins wrote:
> On Tue, May 25, 2010 at 10:14 AM, Greg KH <gregkh@suse.de> wrote:
> > On Mon, May 24, 2010 at 06:50:20PM -0700, Hugh Dickins wrote:
> >> On Mon, May 24, 2010 at 4:15 PM, Greg KH <gregkh@suse.de> wrote:
> >> >
> >> > 2.6.33-stable review patch.  If anyone has any objections, please let us know.
> >> >
> >> > ------------------
> >> > From: Frank Arnold <frank.arnold@amd.com>
> >> >
> >> > commit 7f284d3cc96e02468a42e045f77af11e5ff8b095 upstream.
> >>
> >> Closer, but aren't all the XX/34s intended for 2.6.32.14, not 2.6.33.5?
> >
> > Yes.  This one is a XX/39 and for the .33 tree.
> 
> Sorry for wasting your time with that noise: you must think I'm mad,
> but it appears to be a delightful feature of gmail, combining similar mails:
> to me the Subject line says 20/34, but looking at marc I find as you say,
> that I have replied to 28/39.
> 
> That's going to be a problem!

Sounds like a gmail problem, I would suggest filing a bug for it :)

thanks,

greg k-h
