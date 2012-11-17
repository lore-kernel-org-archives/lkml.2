Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab2KQOuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 09:50:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53620 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab2KQOuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 09:50:09 -0500
Date: Sat, 17 Nov 2012 15:50:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3, v5] AMD64 EDAC: Add muli-domain support
Message-ID: <20121117145030.GG16441@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1352095526-6522-1-git-send-email-daniel@numascale-asia.com>
 <20121112132436.GC5162@x1.osrc.amd.com>
 <50A5FD5C.5030505@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50A5FD5C.5030505@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 04:46:20PM +0800, Daniel J Blueman wrote:
> Yep, the expected memory controller indexes, population, column-strobe
> rows, banks and sysfs paths are detected on my hex-northbridge fam10h
> box with 3.7-rc5 with these patches:

Thanks, it looks correct to me.

-- 
Regards/Gruss,
Boris.
