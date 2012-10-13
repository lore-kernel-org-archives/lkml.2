Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2JMH1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 03:27:45 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60955 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2JMH1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 03:27:44 -0400
X-Auth-Info: N96lCN6WePtmIURbrp2kuv0saEHAAPi39tsZo1wPNTc=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, halfdog <me@halfdog.net>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] binfmt_script: do not leave interp on stack
References: <20121012023240.GA24232@www.outflux.net>
X-Yow: Now I'm being INVOLUNTARILY shuffled closer to the CLAM DIP
 with the BROKEN PLASTIC FORKS in it!!
Date: Sat, 13 Oct 2012 09:27:36 +0200
In-Reply-To: <20121012023240.GA24232@www.outflux.net> (Kees Cook's message of
	"Thu, 11 Oct 2012 19:32:40 -0700")
Message-ID: <m24nlyx253.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> +	/*
> +	 * Since bprm is already modified, we cannot continue if the the

s/the the/the/

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
