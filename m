Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1GCTiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 15:38:00 -0400
Received: from mail.perches.com ([173.55.12.10]:3505 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab1GCTh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 15:37:58 -0400
Subject: Re: [kernel-hardening] Re: [RFC v1] implement SL*B and stack
 usercopy runtime checks
From: Joe Perches <joe@perches.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <20110703192442.GA9504@albatros>
References: <20110703111028.GA2862@albatros>
	 <CA+55aFzXEoTyK0Sm-y=6xGmLMWzQiSQ7ELJ2-WL_PrP3r44MSg@mail.gmail.com>
	 <20110703185709.GA7414@albatros>
	 <CA+55aFwuvk7xifqCX=E3DtV=JCJEzyODcF4o6xLL0U1N_P-Rbg@mail.gmail.com>
	 <20110703192442.GA9504@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Jul 2011 12:37:55 -0700
Message-ID: <1309721875.18925.30.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-03 at 23:24 +0400, Vasiliy Kulikov wrote:
> Btw, if the perfomance will be acceptable, what do you think about
> logging/reacting on the spotted overflows?

If you do, it might be useful to track the found location(s)
and only emit the overflow log entry once as found.

Maybe use __builtin_return_address(depth) for tracking.

