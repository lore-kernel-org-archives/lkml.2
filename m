Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab1GKVBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:01:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165Ab1GKVBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:01:00 -0400
Date: Mon, 11 Jul 2011 14:00:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        cl@linux.com, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: page->_count build failure [was: mmotm 2011-07-08-12-50
 uploaded]
Message-Id: <20110711140048.37100be8.akpm@linux-foundation.org>
In-Reply-To: <CAOJsxLH-3oYgSXO+sNs23+MBeKMsFitkMpHn8LXz=vBZHb2i4g@mail.gmail.com>
References: <201107082028.p68KSWWf013053@imap1.linux-foundation.org>
	<4E1B5CAA.7070001@gmail.com>
	<20110711134121.54557e28.akpm@linux-foundation.org>
	<CAOJsxLG3jjjebBPbZjWTzue7nZJFMWVGZ3iGK41cjGpdKi477Q@mail.gmail.com>
	<4E1B615B.3040509@gmail.com>
	<CAOJsxLH-3oYgSXO+sNs23+MBeKMsFitkMpHn8LXz=vBZHb2i4g@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 23:51:17 +0300
Pekka Enberg <penberg@kernel.org> wrote:

> On Mon, Jul 11, 2011 at 11:47 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> >> Didn't commit ea6bd8ee1a2ccdffc38b2b1fcfe941addfafaade fix the issue?
> >
> > Which repo is that from? Git doesn't know it here.
> 
> It's in slab.git:
> 
> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=ea6bd8ee1a2ccdffc38b2b1fcfe941addfafaade
> 
> Maybe linux-next hasn't picked it up yet?

linux-next won't be updated for another week...
