Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2GYWbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:31:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63349 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2GYWbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:31:33 -0400
MIME-Version: 1.0
In-Reply-To: <50107297.305@pobox.com>
References: <20120725203551.GA19762@havoc.gtf.org> <20120725204350.GA20530@havoc.gtf.org>
 <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com> <50107297.305@pobox.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 Jul 2012 15:31:12 -0700
X-Google-Sender-Auth: AT1nIc446Sb8hAuwL9wCsZF1goM
Message-ID: <CA+55aFzun7GebfGZDa73MGLF_808+ROaei5Ag-9HvgUDp1bqLQ@mail.gmail.com>
Subject: Re: [git patches] libata updates
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 3:26 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
>
> Even so, separately, it still needed that post-merge compile fix.

And that's yet another example of how *NOT* to do things.

If the merge has errors like that, then they should be fixed up in the merge.

Please. Don't do this. Let me merge stuff, and you explain in the pull
request why it gets merge problems. Not this mess.

That merge itself was *trivial*. I do those kinds of fixups in my
sleep and you don't even need to explain those. The non-trivial part
you did as a separate commit. But neither of those should have been
"I'll pre-merge for Linus so that he doesn't see these problems".

          Linus
