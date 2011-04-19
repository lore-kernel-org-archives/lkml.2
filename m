Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1DSBjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:39:16 -0400
Received: from ozlabs.org ([203.10.76.45]:42344 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab1DSBjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:39:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: wanlong.gao@gmail.com, Alessio Igor Bogani <abogani@kernel.org>
Cc: Tim Abbott <tabbott@ksplice.com>, Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH 4/4] module: Use the binary search for symbols resolution
In-Reply-To: <BANLkTik9oekjUH6YXTda1P_dM231nEHQqA@mail.gmail.com>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org> <1302960373-5309-5-git-send-email-abogani@kernel.org> <BANLkTik9oekjUH6YXTda1P_dM231nEHQqA@mail.gmail.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Tue, 19 Apr 2011 11:07:43 +0930
Message-ID: <87liz73tso.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Apr 2011 22:32:08 +0800, Wanlong Gao <wanlong.gao@gmail.com> wrote:
> > +	sym = bsearch(fsa->name, syms->start, syms->stop - syms->start,
> As the bsearch func, why not change the syms->stop to syms->end ?
> Hmm..Just a stupid suggestion.


The names are derived from the linker symbols for end of sections, which
is __stop_<sectionname>.

Cheers,
Rusty.
