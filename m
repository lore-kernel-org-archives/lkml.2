Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab2LUPpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:45:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54223 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab2LUPpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:45:00 -0500
Date: Fri, 21 Dec 2012 16:44:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 6/6] perf annotate: Add --gtk option
Message-ID: <20121221154457.GE15204@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Pekka Enberg <penberg@kernel.org>
References: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
 <1356078018-31905-7-git-send-email-namhyung@kernel.org>
 <20121221083205.GA15226@liondog.tnic>
 <878v8repdt.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <878v8repdt.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 06:16:46PM +0900, Namhyung Kim wrote:
> Current setup_browser() code checks the stdin to be a tty and if
> not it assumes piping to other commands so set the use_browser to 0
> (stdio) and disables GTK output.
>
> Maybe we can change this behavior for --gtk case.

Change it in the sense that for the --gtk case stdin doesn't have to
be a tty? So that with --gtk you can still pipe perf output to other
commands?

I can't imagine a sensible --gtk use case with output piped to other
commands. Hmm.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
