Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab2FUSoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 14:44:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46153 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758794Ab2FUSoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 14:44:08 -0400
Date: Thu, 21 Jun 2012 20:44:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jean Delvare <khali@linux-fr.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH] x86, cpufeature: Fix duplicate feature name "dts"
Message-ID: <20120621184403.GC15472@liondog.tnic>
Reply-To: Borislav Petkov <borislav.petkov@amd.com>
Mail-Followup-To: Borislav Petkov <borislav.petkov@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Jean Delvare <khali@linux-fr.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
	Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
	Jan Beulich <JBeulich@suse.com>
References: <20120621162807.3c621d46@endymion.delvare>
 <4FE34BCB.5050305@linux.intel.com>
 <20120621190743.2e6601f6@endymion.delvare>
 <4FE3628C.6000604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FE3628C.6000604@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 11:06:04AM -0700, H. Peter Anvin wrote:
> On 06/21/2012 10:07 AM, Jean Delvare wrote:
> > 
> > And FWIW, X86_FEATURE_DS has no user in the kernel. Doesn't look like a
> > key feature to me, but maybe my view is biased...
> > 
> 
> No, but apparently perfmon2 depends on it, in userspace, and it relies
> on the string.
> 
> So this is a nonstarter.

Maybe call the sensor thing "dtsen" or something similarly short but not
"dts"?

-- 
Regards/Gruss,
    Boris.
