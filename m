Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1FDIGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 04:06:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41405 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab1FDIGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 04:06:18 -0400
Date: Sat, 4 Jun 2011 10:06:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Thomas Renninger <trenn@suse.de>, Tejun Heo <tj@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup "idle=mwait" removal warning message
Message-ID: <20110604080615.GB17651@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	=?utf-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Thomas Renninger <trenn@suse.de>,
	Tejun Heo <tj@kernel.org>,
	Borislav Petkov <borislav.petkov@amd.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <4DE9E041.5000609@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DE9E041.5000609@freemail.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 04, 2011 at 09:35:29AM +0200, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Cleanup the warning message. This will remove the following warning message
> when compiling:
> 
>  * arch/x86/kernel/process.c:645:1: warning: unknown escape sequence '\i'

Yeah, yours is correct.

But I think we fixed that already in an orchestrated and concentrated
effort of at least 4 people fixing one printk string culminating in
Linus intervening with an evil merge: af0d6a0a

:-)

Keep up the good work, though, the next issue is right around the
corner, I'm sure.

-- 
Regards/Gruss,
    Boris.
