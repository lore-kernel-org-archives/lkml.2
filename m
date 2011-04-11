Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1DKTJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 15:09:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab1DKTJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 15:09:30 -0400
Date: Mon, 11 Apr 2011 11:56:25 -0700
From: Greg KH <gregkh@suse.de>
To: Roland Dreier <roland@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Julien Tinnes <jln@google.com>,
        Klaus Dittrich <kladit@arcor.de>
Subject: Re: [PATCH v2] Relax si_code check in rt_sigqueueinfo and
 rt_tgsigqueueinfo
Message-ID: <20110411185625.GA31235@suse.de>
References: <1301346815-6755-1-git-send-email-roland@kernel.org>
 <20110329121937.GA27497@redhat.com>
 <AANLkTimb+Kdf9KUNpvMA9qOEZWuPFLsLiwwqZB9M+Awn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimb+Kdf9KUNpvMA9qOEZWuPFLsLiwwqZB9M+Awn@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 10:26:55AM -0700, Roland Dreier wrote:
> On Tue, Mar 29, 2011 at 5:19 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Thanks, I think -stable needs this patch asap. It turns out 2.6.32.36, 2.6.33.9,
> > 2.6.37.6 and 2.6.38.2 pulled da48524eb20662618854bb3df2db01fc65f3070c.
> 
> Agree... the commit in Linus's tree is tagged for stable@.
> 
> The only issue I think is that Greg said he's not doing any more
> 2.6.37 releases?
> 
> Greg, this bug breaks the glibc test suite so maybe it's worth doing one more
> release?

Hm, I just checked the distros that I know of that are using the .37
kernel and they already have this patch in them, so it's not really
worth it to me to do another spin of the .37-stable tree.  Especially as
I'd like to have everyone move on to .38-stable instead.

thanks,

greg k-h
