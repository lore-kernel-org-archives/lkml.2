Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab2LPSRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 13:17:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52469 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab2LPSRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 13:17:32 -0500
Date: Sun, 16 Dec 2012 19:17:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Yinghai Lu <yinghai@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v3 04/10] x86/microcode_core_early.c: Define interfaces
 for early loading ucode
Message-ID: <20121216181726.GA14643@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Yu, Fenghua" <fenghua.yu@intel.com>, H Peter Anvin <hpa@zytor.com>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	"Mallick, Asit K" <asit.k.mallick@intel.com>,
	Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Yinghai Lu <yinghai@kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
References: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com>
 <1355654609-16800-5-git-send-email-fenghua.yu@intel.com>
 <20121216175722.GA14678@liondog.tnic>
 <3E5A0FA7E9CA944F9D5414FEC6C71220470F814C@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C71220470F814C@ORSMSX105.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 06:09:12PM +0000, Yu, Fenghua wrote:
> Nothing wrong with taking the parameters. But CPUID_IS is only limited
> in this file. There is no other places to use it. I think either way
> is ok.

Please don't do this. Anything can happen, someone can copy it somewhere
else and try to use it, unification, code movement can all of a sudden
break things in the most mysterious ways.

However, if you make the macro definition self-contained. none of those
issues will happen.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
