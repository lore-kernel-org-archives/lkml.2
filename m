Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2GDNe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 09:34:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab2GDNe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 09:34:56 -0400
Date: Wed, 4 Jul 2012 15:34:55 +0200
From: Jan Kara <jack@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.5-rc5
Message-ID: <20120704133455.GC29954@quack.suse.cz>
References: <1341342768-22221-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341342768-22221-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 03-07-12 21:12:48, Geert Uytterhoeven wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.5-rc5[1] compared to v3.4[2].
> 
> Too make this mail fit in the lkml limit, I deleted
>   - all implicit function declaration error improvements
>   - 245 lines about __mcount_loc on sparc64
>   - all warning improvements
> 
> Summarized:
>   - build errors: +227/-575
>   - build warnings: +644/-805
> 
> JFYI, when comparing v3.5-rc5 to v3.5-rc4[3], the summaries are:
>   - build errors: +20/-11
>   - build warnings: +130/-533
> 
> Note that there may be false regressions, as some logs are incomplete.
> Still, they're build errors/warnings.
> 
> As I haven't mastered kup yet, there's no verbose summary at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.5-rc5.summary.gz
> 
> Happy fixing! ;-)
> 
> Thanks to the linux-next team for providing the build service.
...
>   + fs/quota/quota_tree.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 372:4
>   + fs/quota/quota_v2.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'ssize_t' [-Wformat]:  => 66:92
  These really look like false positives (there are quite a few of this
kind). Can we possibly silence them?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
