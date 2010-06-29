Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0F2Wff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 18:35:35 -0400
Received: from clueserver.org ([65.102.45.174]:59448 "EHLO clueserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab0F2Wfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 18:35:34 -0400
Subject: Re: [stable] [PATCH for stable] kbuild: Fix modpost segfault
From: Alan <alan@clueserver.org>
To: Greg KH <greg@kroah.com>
Cc: Michal Marek <mmarek@suse.cz>, stable@kernel.org,
       linux-kernel@vger.kernel.org,
       Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khc@pm.waw.pl>
In-Reply-To: <20100629133932.GA30146@kroah.com>
References: <20100629094341.GA26045@sepie.suse.cz>
	 <20100629125422.GB29243@kroah.com> <4C29F61A.2090905@suse.cz>
	 <20100629133932.GA30146@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Jun 2010 15:35:32 -0700
Message-ID: <1277850932.6499.2.camel@zowie.clueserver.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 06:39 -0700, Greg KH wrote: 
> On Tue, Jun 29, 2010 at 03:33:14PM +0200, Michal Marek wrote:
> > On 29.6.2010 14:54, Greg KH wrote:
> > > On Tue, Jun 29, 2010 at 11:43:42AM +0200, Michal Marek wrote:
> > >> Hi Greg,
> > >>
> > >> please add this to stable, it's a bug that started showing up with newer
> > >> gcc. The upstream commit is 1c938663d58b5b2965976a6f54cc51b5d6f691aa.
> > > 
> > > What -stable kernels do you want it applied to?  .27, .32, .33, and/or
> > > .34?
> > 
> > I'd say all of them. I just tried it and applies cleanly.
> 
> Ok, thanks, will do.

Thanks.  That fixes a major build problem for me.


