Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1E0RRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:17:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab1E0RRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:17:30 -0400
MIME-Version: 1.0
In-Reply-To: <4DDFDBD2.2000904@zytor.com>
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl>
 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com> <20110527170045.GB4356@elte.hu>
 <1306516230.3339.17.camel@dan> <4DDFDBD2.2000904@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 May 2011 10:16:37 -0700
Message-ID: <BANLkTin=VV_1rny+5EgwJXj1SQ45c2KKsw@mail.gmail.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:13 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> You can read the on-disk kernel file and find out.

So? Make it root-readable-only. Problem solved.

That's the _only_ difference, and it's trivial and irrelevant. Come up
with something more real, please.

                 Linus
