Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab1APVGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:06:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752Ab1APVGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:06:04 -0500
MIME-Version: 1.0
In-Reply-To: <1295076096.4875.60.camel@pasglop>
References: <4d308cf5394566ccc@agluck-desktop.sc.intel.com> <1295076096.4875.60.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Jan 2011 13:05:15 -0800
Message-ID: <AANLkTikZ+MmM9f0tidpccDAimtUkDvJ3N=3KE+xFxc63@mail.gmail.com>
Subject: Re: ia64 broken by transparent huge pages - other arches too?
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 11:21 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> This is insane. Having such a massively invasive change to the whole mm,
> barely tested on most architecture, and last I heard still generally
> controversial being merged like that without even some integration
> testing via -next makes no sense.
>
> Linus, wtf is going on ?

I pretty much take anything from Andrew, unless I hate it (and the
latest version of the transparent huge-page was ok).

That said, I did think that Andrew's -mm tree was in -next, and there
clearly is some serious problem wrt -mm and -next if this wasn't
caught earlier there.

I was also expecting the fixups to come through Andrew, and they
haven't. I can apply whatever people agree is sane, but right now I
don't even know what the final patch for this problem is.

                        Linus
