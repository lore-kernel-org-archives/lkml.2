Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab2LUPOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:14:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59986 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab2LUPO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:14:29 -0500
Date: Fri, 21 Dec 2012 16:14:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v4 00/11] x86/microcode: Early load microcode
Message-ID: <20121221151418.GC15226@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	Michael Tokarev <mjt@tls.msk.ru>, H Peter Anvin <hpa@zytor.com>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	"Mallick, Asit K" <asit.k.mallick@intel.com>,
	Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
	Yinghai Lu <yinghai@kernel.org>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Borislav Petkov <borislav.petkov@amd.com>,
	linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
References: <1356032893-2730-1-git-send-email-fenghua.yu@intel.com>
 <50D42626.40708@msgid.tls.msk.ru>
 <3E5A0FA7E9CA944F9D5414FEC6C7122047109B7E@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C7122047109B7E@ORSMSX105.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 03:09:48PM +0000, Yu, Fenghua wrote:
> > Why loading microcode this early is important? Why it is bad to load
> > it at the end of (initial) boot?
> >
> If not loading microcode early, we may hit some issues (e.g. PSE on
> Atom) and disable some CPU features. These issues can not be fixed by
> loading ucode during run time.

This question keeps popping up with this patchset, maybe you could
enlarge the first paragraph of Documentation/x86/early-microcode.txt
with a bit more detail and examples.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
