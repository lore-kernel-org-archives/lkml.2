Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2LXNSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 08:18:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56018 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2LXNSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 08:18:20 -0500
Date: Mon, 24 Dec 2012 14:18:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 6/6] perf annotate: Add --gtk option
Message-ID: <20121224131817.GE6702@liondog.tnic>
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
 <20121221154457.GE15204@liondog.tnic>
 <CAM9d7cj2mtQ5=vzLeAREA4kUYKh_qJYi+c2AVry6eK1H58f+zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAM9d7cj2mtQ5=vzLeAREA4kUYKh_qJYi+c2AVry6eK1H58f+zA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 03:04:59PM +0900, Namhyung Kim wrote:
> Right.  I also have no idea what's the best way to handle --gtk option
> with the piped output.  I can think of 3 options for this:
> 
> 1) exit with a error message
> 2) honor --gtk option and launch a gui browser

I could befriend #2, probably. Reasoning? Well, user gets what she
requested: --gtk with piped output and if it works, we give it to her.

Of course, I'm hardly the person to ask about user-visible stuff so
maybe the others would have a more sensible idea :-).

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
