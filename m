Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab1HPPDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:03:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58628 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab1HPPDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:03:34 -0400
Message-ID: <4E4A8696.3040400@zytor.com>
Date: Tue, 16 Aug 2011 08:02:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        rdunlap@xenotime.net, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/vdso] x86, vsyscall: Add missing <asm/fixmap.h> to arch/x86/mm/fault.c
References: <CA+55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5+fqMp_exQ@mail.gmail.com> <tip-87cae8456a55c0a6163deca66d8aa3a6aa21f764@git.kernel.org> <CAOJsxLFH6=OtDO8VErc1A_Waf89bRO53_Axnecc06TrUGmLZ1g@mail.gmail.com>
In-Reply-To: <CAOJsxLFH6=OtDO8VErc1A_Waf89bRO53_Axnecc06TrUGmLZ1g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 11:43 PM, Pekka Enberg wrote:
> 
> The commit subject line says <asm/fixmap.h> which is wrong, right?
> 
>                              Pekka
> 

Argh... no, I accidentally committed the wrong version of the patch.

	-hpa
