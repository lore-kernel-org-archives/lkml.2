Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab1INQIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:08:06 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56898 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662Ab1INQIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:08:05 -0400
Subject: Re: [PATCH v2 10/10] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg@redhat.com>, x86@kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>,
        Matt Domsch <Matt_Domsch@dell.com>
In-Reply-To: <4E6F69A1.9030406@gmail.com>
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
	 <1315838094-2307-11-git-send-email-matt@console-pimps.org>
	 <4E6F69A1.9030406@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 17:07:58 +0100
Message-ID: <1316016478.3466.74.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 16:33 +0200, Maarten Lankhorst wrote:
> This version seems to boot for me.

Yay! Thanks for testing.

> Is it useful to add 32-bits support though?
> It seems that only some older versions of OSX use it. I could see if I can
> revive my mac mini, iirc it has 32-bits efi, or at least used to have.

32-bit UEFI platforms do exist, so I think it's worth supporting them.

> Do I need to pass anything to add it to efibootmgr?
> 
> I tried something like this:
> echo "args" | efibootmgr -c -l '\vmlinuz.efi' -L 'Native EFI linux boot' -@ - -u -d /dev/sdb
> 
> And it boots vmlinuz.efi, but the arguments I passed do not appear to
> have any effect.

No idea, I've never used efibootmgr. Let's add Matt Domsch to the
discussion (now Cc'd).

-- 
Matt Fleming, Intel Open Source Technology Center

