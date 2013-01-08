Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3AHP71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 10:59:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33125 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab3AHP70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 10:59:26 -0500
Date: Tue, 8 Jan 2013 16:59:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: "lkml@tigusoft.pl" <lkml@tigusoft.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.2.35 problem with M5A97 PRO ram: bad_page free_pages_prepare
 mem_init
Message-ID: <20130108155923.GA8350@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"lkml@tigusoft.pl" <lkml@tigusoft.pl>, linux-kernel@vger.kernel.org
References: <kcfoae$91e$1@ger.gmane.org>
 <kcfoq8$dac$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <kcfoq8$dac$1@ger.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 01:21:26AM +0100, lkml@tigusoft.pl wrote:
> On 08/01/13 01:13, lkml@tigusoft.pl wrote:
> 
> > linux kernel
> > 3.2.0-0.bpo.4-rt-amd64 #1 SMP PREEMPT RT Debian 3.2.35-2~bpo60+1 x86_64
> > GNU/Linux
> 
> will post later how it behaves on vanilla 3.2.36 and 3.7.1

Yes, also, if your DRAM supports ECC, try enabling it in the BIOS.
This board should support ECC. Then, enable CONFIG_EDAC_AMD64 and
CONFIG_EDAC_DECODE_MCE to check whether it catches any DRAM errors.

If your DRAM is non-ECC, try consecutively swapping out a DIMM each time
and booting to see whether removing one of the DIMMs makes the errors go
away.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
