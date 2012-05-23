Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564Ab2EWQy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:54:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39575 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2EWQyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:54:25 -0400
Date: Wed, 23 May 2012 18:54:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        frank.arnold@amd.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mce] x86/mce: Fix 32-bit build
Message-ID: <20120523165423.GC18284@liondog.tnic>
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
 <20120523164404.GA18284@liondog.tnic>
 <1337791605.9783.31.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1337791605.9783.31.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 06:46:45PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-23 at 18:44 +0200, Borislav Petkov wrote:
> 
> > FWIW, I can change it if you feel too strongly about it, I don't really
> > care that much.
> 
> I don't care much at the moment, I might if I'm ever forced to actually
> read the MCE code, but until that time I'll crawl back into my
> corner :-)

Well, our job is to make it as unreadable as possible until that time
comes.

:-)

-- 
Regards/Gruss,
    Boris.
