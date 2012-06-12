Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2FLVAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:00:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59554 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab2FLU77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:59:59 -0400
Date: Tue, 12 Jun 2012 22:59:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally
Message-ID: <20120612205956.GB26817@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	x86@kernel.org, eranian@google.com, linux-kernel@vger.kernel.org,
	a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
References: <1339533234-2265-1-git-send-email-andi@firstfloor.org>
 <20120612204917.GA26817@liondog.tnic>
 <4FD7ABFE.6090801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FD7ABFE.6090801@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 01:52:14PM -0700, H. Peter Anvin wrote:
> Different CPUs in a multisocket system may have different compatible
> ucode versions.

Ah, so you need the different ucode for the different steppings of the
cpus on the board, right? Assuming ucode versions are incremented per
F:M:S tuple, of course, then you can have different compatible microcode
versions.

> Of course, I am not even sure if it makes any sense at all to compare
> microcode versions without qualifying them with F:M:S.

Yep.

-- 
Regards/Gruss,
    Boris.
