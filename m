Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab0KSSpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:45:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:34787 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab0KSSpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:45:02 -0500
Date: Fri, 19 Nov 2010 16:44:38 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Robert Morell <rmorell@nvidia.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] perf: Remove hardcoded include paths for
	elfutils
Message-ID: <20101119184438.GB23996@ghostprotocols.net>
References: <1289945793-31441-1-git-send-email-rmorell@nvidia.com> <4CE339C3.6070009@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE339C3.6070009@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 17, 2010 at 11:11:15AM +0900, Masami Hiramatsu escreveu:
> (2010/11/17 7:16), Robert Morell wrote:
> > This change removes the use of hardcoded absolute
> > "/usr/include/elfutils" paths from the perf build.  The problem with
> > hardcoded paths is that it prevents them from being overridden by
> > $prefix or by -I in CFLAGS (e.g., for cross-compiling purposes).
> > 
> > Instead, just include the "elfutils/" subdirectory as a relative path
> > when files are needed from that directory.
> 
> Looks good to me, Thanks!
> 
> > 
> > Tested by building perf:
> > - Cross-compiled for ARM on x86_64
> > - Built natively on x86_64
> > - Built on x86_64 with /usr/include/elfutils moved to another location
> >   and manually included in CFLAGS
> > 
> > Signed-off-by: Robert Morell <rmorell@nvidia.com>
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks, applied,

- Arnaldo
