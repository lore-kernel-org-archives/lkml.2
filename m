Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab1BUC1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 21:27:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33783 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab1BUC1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 21:27:11 -0500
Date: Mon, 21 Feb 2011 03:27:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        torvalds@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: Add extra gcc checks
Message-ID: <20110221022707.GB18332@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joe Perches <joe@perches.com>, Sam Ravnborg <sam@ravnborg.org>,
	Michal Marek <mmarek@suse.cz>, torvalds@linux-foundation.org,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, linux-kbuild@vger.kernel.org
References: <1298219710-9846-1-git-send-email-bp@alien8.de>
 <20110220175709.GA5178@merkur.ravnborg.org>
 <20110220193906.GC6713@liondog.tnic>
 <1298232047.1284.14.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1298232047.1284.14.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 12:00:47PM -0800, Joe Perches wrote:
> > +EXTRA_CFLAGS += -Wextra -Wno-unused
> 
> Why add -Wno-unused ?
> 
> If it's because of verbosity, maybe

Nah, it's because it is too noisy and spits too many false positives.
For example, it reports the arguments of all those stubs from the
headers which are provided for the else-branch of a CONFIG_* option,
etc.

-- 
Regards/Gruss,
    Boris.
