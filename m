Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab2JBVbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:31:44 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44247 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab2JBVbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <1349202763-1601-1-git-send-email-geert@linux-m68k.org>
References: <1349202763-1601-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 3 Oct 2012 00:31:42 +0300
Message-ID: <CAJL_dMuCO6kvrHKkYU47nbp0=LbT5nMHo6WWkK0u5SjWXEtUWw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.6
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <greg@linux-foundation.org>, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 9:32 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.6[1] compared to v3.5[2].
>
> To make this mail fit in the lkml limit, I deleted
>   - 6008 lines about __mcount_loc on sparc64
>
> Summarized:
>   - build errors: +56/-119
>   - build warnings: +6296/-246
>
> JFYI, when comparing v3.6 to v3.6-rc7[3], the summaries are:
>   - build errors: +4/-1
>   - build warnings: +716/-107
>
> Note that there may be false regressions, as some logs are incomplete.
> Still, they're build errors/warnings.
>
> As I haven't mastered kup yet, there's no verbose summary at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.6.summary.gz
>
> Happy fixing! ;-)

More errors, more warnings...
