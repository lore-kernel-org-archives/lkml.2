Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3ACM0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:26:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50273 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab3ACMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:19:42 -0500
Date: Thu, 3 Jan 2013 13:19:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefan Hasko <hasko.stevo@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: x86: boot: compressed: eboot: fix cast warnings on
 32b platforms
Message-ID: <20130103121952.GB10243@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Stefan Hasko <hasko.stevo@gmail.com>,
	Matt Fleming <matt.fleming@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1356171805-16930-1-git-send-email-hasko.stevo@gmail.com>
 <20121226080019.GB11555@liondog.tnic>
 <50E31E18.5010404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50E31E18.5010404@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2013 at 09:34:16AM -0800, H. Peter Anvin wrote:
> Yes, but stylistically: we don't use uintptr_t in Linux, but rather
> "unsigned long".

Hmmkay,

Stefan, care to redo your patch and sum up this discussion to the commit
message for further reference?

Btw, there is some funny usage of uintptr_t in
arch/x86/include/asm/xor_avx.h and since this is not an uapi header,
they need to be converted to unsigned long too, methinks.

Thanks.

-- 
Regards/Gruss,
Boris.
