Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab0HNNnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 09:43:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:40018 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab0HNNnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 09:43:18 -0400
Date: Sat, 14 Aug 2010 06:39:42 -0700
From: Greg KH <gregkh@suse.de>
To: Pekka Enberg <penberg@kernel.org>
Cc: Arthur Titeica <arthur@psw.ro>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.35.2
Message-ID: <20100814133942.GA17430@suse.de>
References: <20100813212313.GA22102@kroah.com> <a00737cba20cb46512a2248e0477cc0b@linux.psw.ro> <AANLkTi=YfKZkE6ee6rE9LvtAiQ6F0YaTHbN+O_dTGHKb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=YfKZkE6ee6rE9LvtAiQ6F0YaTHbN+O_dTGHKb@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 02:21:31PM +0300, Pekka Enberg wrote:
> On Sat, Aug 14, 2010 at 1:35 PM, Arthur Titeica <arthur@psw.ro> wrote:
> > On Fri, 13 Aug 2010 14:23:13 -0700, Greg KH <gregkh@suse.de> wrote:
> >> I'm announcing the release of the 2.6.35.2 kernel.
> >>
> >> All users of the 2.6.35 kernel series must upgrade.
> >>
> >
> > I'm not sure this is the right mailing list but this is the first
> > kernel that fails to boot for me (since 2.6.33.x).
> >
> > The laptop just restarts right after "Freeing unused kernel memory:
> > 628k freed"
> >
> > 2.6.35.1 is fine with the same .config.
> >
> > Anyone willing to help me to debug?
> 
> You could try 'git bisect' between v2.6.35.1 and v2.6.35.2 to narrow
> the problem down to a specific commit.

Yes, if you could please do that, it would be most appreciated.

thanks,

greg k-h
