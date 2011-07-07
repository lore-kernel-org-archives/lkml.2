Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1GGNe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:34:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab1GGNe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:34:26 -0400
Date: Thu, 7 Jul 2011 06:33:44 -0700
From: Greg KH <gregkh@suse.de>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: axboe@kernel.dk, kay.sievers@vrfy.org,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.38.8] Bisected to commit
 5fb46ae7b8c51b05a12c6a66108e8d398c20ee09
Message-ID: <20110707133344.GB26301@suse.de>
References: <4E11BAE0.5020208@t-online.de>
 <20110707003338.GA25302@suse.de>
 <4E1534DC.3020306@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1534DC.3020306@t-online.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 06:23:56AM +0200, Knut Petersen wrote:
> Am 07.07.2011 02:33, schrieb Greg KH:
> > On Mon, Jul 04, 2011 at 03:06:40PM +0200, Knut Petersen wrote:
> >> Hi everybody!
> >>
> >> An openSuse 11.2 system reliably refused to boot properly with kernel 2.6.38.8
> >> although the prior 2.6.38.y kernels worked fine.  After a few seconds booting
> >> stopped. Several <ctrl-c> did help, but a lot of services were not started properly,
> >> only the root partition was available. Nothing unusual could be found in the
> >> kernel messages.
> >>
> >> I bisected the problem to commit 5fb46ae7b8c51b05a12c6a66108e8d398c20ee09.
> >>
> >> That gave me the idea to disconnect the Plextor PX-755A dvd drive  and to
> >> try 2.6.38.8 again. It booted without problem.
> > Does the 2.6.39.2 kernel work properly for you?
> >
> Yes.  Kernel 2.6.38[,1,2,3,4,5,6,7] 2.6.39[1,2] 3.0-git are ok, only 2.6.38.8 is broken in the
> way described above.

Good.  You do know that 2.6.38.y is end-of-life and you should move on
to 2.6.39, right?  There's nothing I can do right now for the .38 series
to resolve this, sorry.

greg k-h
