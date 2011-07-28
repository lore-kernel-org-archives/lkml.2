Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab1G1K6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:58:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab1G1K6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:58:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1311761831.24752.413.camel@twins>
References: <1311761831.24752.413.camel@twins> <1311757190.24752.406.camel@twins> <1310717238-13857-1-git-send-email-haishan.bai@gmail.com> <1310717238-13857-2-git-send-email-haishan.bai@gmail.com> <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com> <1310860194.25044.17.camel@pasglop> <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com> <1310912990.25044.203.camel@pasglop> <1310944453.25044.262.camel@pasglop> <1310961691.25044.274.camel@pasglop> <4E23D728.7090406@gmail.com> <1310972462.25044.292.camel@pasglop> <4E23E02C.8090401@gmail.com> <1310974591.25044.298.camel@pasglop> <4E24FA51.70602@gmail.com> <1311049762.25044.392.camel@pasglop> <CAMjpGUdxpaYBFfKjBEPFOJohnKoXfagLUHvhrst+NembeabxcA@mail.gmail.com> <1311753513.25044.663.camel@pasglop> <20368.1311761379@redhat.com> 
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Shan Hai <haishan.bai@gmail.com>, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, cmetcalf@tilera.com, tony.luck@intel.com,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW tracking of dirty & young
Date: Thu, 28 Jul 2011 11:55:50 +0100
Message-ID: <5178.1311850550@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> Subject: mm: Fix fixup_user_fault() for MMU=n 
> 
> In commit 2efaca927 ("mm/futex: fix futex writes on archs with SW
> tracking of dirty & young") we forgot about MMU=n. This patch fixes
> that.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: David Howells <dhowells@redhat.com>
