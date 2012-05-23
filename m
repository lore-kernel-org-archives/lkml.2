Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2EWQoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:44:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48427 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab2EWQoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:44:09 -0400
Date: Wed, 23 May 2012 18:44:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        frank.arnold@amd.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mce] x86/mce: Fix 32-bit build
Message-ID: <20120523164404.GA18284@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org,
	hpa@zytor.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, frank.arnold@amd.com,
	torvalds@linux-foundation.org, tglx@linutronix.de,
	linux-tip-commits@vger.kernel.org
References: <1337684026-19740-2-git-send-email-bp@amd64.org>
 <tip-80f033610fb968e75f5d470233d8d0260d7a72ed@git.kernel.org>
 <1337789898.9783.19.camel@laptop>
 <20120523162335.GO14757@aftab.osrc.amd.com>
 <1337790667.9783.29.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1337790667.9783.29.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 06:31:07PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-23 at 18:23 +0200, Borislav Petkov wrote:
> > I know but I have the exact bit name from the BKDG in the comment above
> > - CntP - and this is used only at one place - here - so no need for the
> > defines, IMHO. 
> 
> Yes, but CntP is such a good name that it actually forced me to look at
> the BKDG to figure out wtf it meant ;-)

Yeah, this is quirks code - you're not supposed to look at it at all :-)

FWIW, I can change it if you feel too strongly about it, I don't really
care that much.

Thanks.

-- 
Regards/Gruss,
    Boris.
