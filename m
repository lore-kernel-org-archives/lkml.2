Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab2CZEYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 00:24:36 -0400
Received: from ozlabs.org ([203.10.76.45]:51069 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab2CZEYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 00:24:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jim Cromie <jim.cromie@gmail.com>, Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [00/11] pr_debug during module initialization
In-Reply-To: <CAJfuBxztMMUrbUvVft8gXB4Jk2yi+AXVV-TVLXAFdtgMf4AUgg@mail.gmail.com>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com> <20120323202713.GA6039@redhat.com> <CAJfuBxztMMUrbUvVft8gXB4Jk2yi+AXVV-TVLXAFdtgMf4AUgg@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 26 Mar 2012 10:54:30 +1030
Message-ID: <87ehsgcipt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012 18:12:51 -0600, Jim Cromie <jim.cromie@gmail.com> wrote:
> > A previous version had a build-time error if a module used 'dyndbg' as a
> > module param - why did that get dropped?
> 
> Rusty expressed view that if developers add it, they meant it.
> He also said the macro was redundant with another,
> but I didnt look further cuz of the 1st point.

Yeah, it was ugly overkill.  I can't see someone accidently overriding
dyndbg, and let's assume that they know what they're doing (who knows,
they might want to enhance the parsing before calling the real dyndbg
parser).

Cheers,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
