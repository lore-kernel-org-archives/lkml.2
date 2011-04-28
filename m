Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1D1MgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:36:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54536 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab1D1MgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:36:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: re-use kernel/syscall_table_32.S in ia32/ia32entry.S
Date: Thu, 28 Apr 2011 14:35:33 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Jan Beulich <JBeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
References: <4DB85376020000780003E6C9@vpn.id2.novell.com> <201104271840.32015.arnd@arndb.de> <4DB847BF.1060307@zytor.com>
In-Reply-To: <4DB847BF.1060307@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104281435.33344.arnd@arndb.de>
X-Provags-ID: V02:K0:VwbHVSXcrLq6CM1praW3Ob/kkJgX2ySvAfLLGhkl2gi
 bdXNN4XF9BlIl1HrjUid14EJpUq9b6KwDZlEHHUFswN7263poM
 r2HQOXGkUr4m7t95SENGxXas/7TbugakLiPSMfksfUgsZtioHs
 NltlOIJa2RQv3Yu3jbODMBXSmw3tDsWPrIX4hJ7rGeSPpDXpAT
 Iz04rqCa75i2A78UxPNpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011, H. Peter Anvin wrote:
> On 04/27/2011 09:40 AM, Arnd Bergmann wrote:
> >>
> >> Yes, that's certainly an alternative.
> > 
> > How about following the same style as asm-generic/unistd.h? It's
> > originally derived from the x86 version, but has added support for
> > compat syscalls for the tile architecture.
> > 
> 
> Yep, something like that (although I have to say the __SC_3264 syntax
> makes me want to barf.)

If you have a suggestion for a better syntax, I'd hope we can do
that in asm-generic as well. My goal is to have those files set
an example of how to best write architecture specific versions if
they have to be different.

	Arnd
