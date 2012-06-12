Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2FLWTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:19:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46059 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab2FLWTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:19:34 -0400
Date: Wed, 13 Jun 2012 00:19:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally v2
Message-ID: <20120612221931.GA4376@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
	x86@kernel.org, hpa@zytor.com, eranian@google.com,
	linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
References: <1339536350-10463-1-git-send-email-andi@firstfloor.org>
 <20120612213905.GE26817@liondog.tnic>
 <4FD7BE15.50604@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FD7BE15.50604@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 03:09:25PM -0700, Andi Kleen wrote:
> 
> >Ok, is it only me or is this boot_min_microcode superfluous?
> >IOW, you can only use boot_cpu_data.microcode instead and drop
> >boot_min_microcode.
> 
> boot_cpu_data.microcode contains a copy of the original microcode,
> so we couldn't detect the boot cpu case. In theory could hard code
> CPU #0 is boot cpu or so,
> but I prefer to track it with the separate variable.

Ok, this begs the next question then: why do we need to say that some AP
has a lower ucode version than the BSP?

-- 
Regards/Gruss,
    Boris.
