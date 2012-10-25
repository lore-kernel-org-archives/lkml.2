Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab2JYPX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:23:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60182 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab2JYPX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:23:27 -0400
Date: Thu, 25 Oct 2012 17:23:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Multiple patch authors
Message-ID: <20121025152328.GE308@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <1351153972-14019-1-git-send-email-daniel@numascale-asia.com>
 <20121025110353.GA2623@aftab.osrc.amd.com>
 <20121025115654.GA27611@gmail.com>
 <20121025135948.GA308@x1.osrc.amd.com>
 <50894D84.9030203@zytor.com>
 <20121025143626.GD308@x1.osrc.amd.com>
 <50894F8E.9060706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50894F8E.9060706@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 07:41:18AM -0700, H. Peter Anvin wrote:
> Not necessarily. It is actually better to have more specific tags for
> different situations.

Do you have any concrete in mind? I mean, we can hash them out now and
put them in the documentation and be done with it.

> There is a reason why tip-bot accepts any tag ending in -by: ...

Fair enough.

-- 
Regards/Gruss,
Boris.
