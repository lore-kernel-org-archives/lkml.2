Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1G1ASc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 20:18:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59671 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab1G1AS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 20:18:29 -0400
MIME-Version: 1.0
In-Reply-To: <1311762043.25044.679.camel@pasglop>
References: <1311757190.24752.406.camel@twins> <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com> <1310725418.2586.309.camel@twins>
 <4E21A526.8010904@gmail.com> <1310860194.25044.17.camel@pasglop>
 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com> <1310912990.25044.203.camel@pasglop>
 <1310944453.25044.262.camel@pasglop> <1310961691.25044.274.camel@pasglop>
 <4E23D728.7090406@gmail.com> <1310972462.25044.292.camel@pasglop>
 <4E23E02C.8090401@gmail.com> <1310974591.25044.298.camel@pasglop>
 <4E24FA51.70602@gmail.com> <1311049762.25044.392.camel@pasglop>
 <CAMjpGUdxpaYBFfKjBEPFOJohnKoXfagLUHvhrst+NembeabxcA@mail.gmail.com>
 <1311753513.25044.663.camel@pasglop> <20368.1311761379@redhat.com>
 <1311761831.24752.413.camel@twins> <1311762043.25044.679.camel@pasglop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 27 Jul 2011 17:12:32 -0700
Message-ID: <CAMjpGUdXfzt5HuDgspf6Bijm3xOPcck_JR38-AV2FSK0t99MTQ@mail.gmail.com>
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW tracking
 of dirty & young
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>,
        Shan Hai <haishan.bai@gmail.com>, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, cmetcalf@tilera.com, tony.luck@intel.com,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 03:20, Benjamin Herrenschmidt wrote:
> Hoping the BUG() isn't trippable by userspace but then it's no mmu, it's
> not like we care what userspace can do right :-)

side note ... common misconception that "no mmu" == "no memory
protection".  a few of the nommu processors have memory protection,
just no virtual<->physical translation.

thanks for the patch !
-mike
