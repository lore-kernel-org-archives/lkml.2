Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab1EXOTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:19:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932471Ab1EXOTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:19:48 -0400
Date: Tue, 24 May 2011 16:19:47 +0200
From: Michal Marek <mmarek@suse.cz>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: do not record timestamp in .config
Message-ID: <20110524141947.GD2276@sepie.suse.cz>
References: <1305516176-4072-1-git-send-email-lacombar@gmail.com>
 <4DD0E06C.2040009@suse.cz>
 <BANLkTi=bZe6T9hM+bUMBM1Jy5xVHP2x9cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=bZe6T9hM+bUMBM1Jy5xVHP2x9cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:16:11AM -0400, Arnaud Lacombe wrote:
> Hi Michal,
> 
> 2011/5/16 Michal Marek <mmarek@suse.cz>:
> > On 16.5.2011 05:22, Arnaud Lacombe wrote:
> >>
> >> Hi Michal,
> >>
> >> The following patch removes the timestamp in .config file. This is a
> >> prerequiresite for the revised version of the printer merge I sent back
> >> in December[0]. The issue is that heading comment generations will be
> >> merged in a single function, and that would revert the deterministic
> >> change you made in mid-April.
> >>
> >> The other options are either to have timestamp always enabled and
> >> disable them selectively, but that might be a pain to implement, or to
> >> have timestamp disable by default and an environment variable, say
> >> KCONFIG_TIMESTAMP, to turn everything on manually.
> >
> > I personally am not a big fan of embedded timestamps, so
> >
> > Acked-by: Michal Marek <mmarek@suse.cz>
> >
> Do you intend to merge that patch for .1 (or whatever Linus decides to
> call the next kernel) ?

I merged it now.

Michal
