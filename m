Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab1B1SYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:24:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41243 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab1B1SYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:24:44 -0500
Date: Mon, 28 Feb 2011 19:24:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>
Cc: torvalds@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kbuild@vger.kernel.org, bp@amd64.org
Subject: Re: [PATCH -v4] kbuild: Add extra gcc checks
Message-ID: <20110228182440.GA12411@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
	torvalds@linux-foundation.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	linux-kbuild@vger.kernel.org, bp@amd64.org
References: <20110221110322.GA9819@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110221110322.GA9819@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 12:03:22PM +0100, Borislav Petkov wrote:
> 
> Add a 'W=1' Makefile switch which adds additional checking per build
> object.
> 
> The idea behind this option is targeted at developers who, in the
> process of writing their code, want to do the occasional
> 
> make W=1 [target.o]
> 
> and let gcc do more extensive code checking for them. Then, they
> could eyeball the output for valid gcc warnings about various
> bugs/discrepancies which are not reported during the normal build
> process.
> 
> For more background information and a use case, read through this
> thread: http://marc.info/?l=kernel-janitors&m=129802065918147&w=2
> 
> -v4: Enable this for gcc only. Also, check for options which are not
> supported by every gcc version we use to build the kernel. Adding those
> checks for _every_ option slows down the build noticeably so be sensible
> here and add it only when your gcc version chokes on a particular
> option.
> 
> -v[2..3]: move to Makefile.build
> 
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: linux-kbuild@vger.kernel.org
> Acked-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Borislav Petkov <bp@alien8.de>

Ping?

Michal, Sam,

any news here? FWIW, I've been build-testing amd64_edac.c with it and
have caught a bunch of buglets with it. IMHO, it really helps to enable
more extensive gcc checking in debugging builds.

Thanks.

-- 
Regards/Gruss,
Boris.
