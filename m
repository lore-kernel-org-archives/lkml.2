Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1HHCcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 22:32:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58673 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1HHCb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 22:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <1311761831.24752.413.camel@twins>
References: <1311757190.24752.406.camel@twins> <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com> <1310725418.2586.309.camel@twins>
 <4E21A526.8010904@gmail.com> <1310860194.25044.17.camel@pasglop>
 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com> <1310912990.25044.203.camel@pasglop>
 <1310944453.25044.262.camel@pasglop> <1310961691.25044.274.camel@pasglop>
 <4E23D728.7090406@gmail.com> <1310972462.25044.292.camel@pasglop>
 <4E23E02C.8090401@gmail.com> <1310974591.25044.298.camel@pasglop>
 <4E24FA51.70602@gmail.com> <1311049762.25044.392.camel@pasglop>
 <CAMjpGUdxpaYBFfKjBEPFOJohnKoXfagLUHvhrst+NembeabxcA@mail.gmail.com>
 <1311753513.25044.663.camel@pasglop> <20368.1311761379@redhat.com> <1311761831.24752.413.camel@twins>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 7 Aug 2011 22:31:35 -0400
Message-ID: <CAMjpGUdVo-s-882wRs7J=q_fgs_CcY2cBsRE8fbmAoVvhkF6Fg@mail.gmail.com>
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW tracking
 of dirty & young
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Shan Hai <haishan.bai@gmail.com>, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, cmetcalf@tilera.com, tony.luck@intel.com,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 06:17, Peter Zijlstra wrote:
> On Wed, 2011-07-27 at 11:09 +0100, David Howells wrote:
>> Can you inline this for the NOMMU case please?
>
> ---
> Subject: mm: Fix fixup_user_fault() for MMU=n
>
> In commit 2efaca927 ("mm/futex: fix futex writes on archs with SW
> tracking of dirty & young") we forgot about MMU=n. This patch fixes
> that.

can we get this merged ?  mainline is now broken, linux-next is still
broken, and it seems gregkh is pulling this into the stable 3.0.1
which means that's going to be broken too.
-mike
