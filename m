Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab2JAUzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:55:38 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61140 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab2JAUzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:55:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120928190552.GA32188@redhat.com>
References: <CA+55aFzJWwBPgqp_QquhncpRqLXHRh0m9hHPh94Ujzd1d7kMDQ@mail.gmail.com>
 <20120904154412.GA14321@redhat.com> <504A3527.9070104@gmail.com>
 <CA+55aFwh5kUDC_5-_4_TkqnQU73sotAkOs166ag4R3Fx8VKffw@mail.gmail.com>
 <1347287780.2124.10.camel@twins> <20120921211639.GA17379@redhat.com> <20120928190552.GA32188@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Oct 2012 13:55:10 -0700
X-Google-Sender-Auth: uWMbjy0e9gpe87UHbm4CdhudBr4
Message-ID: <CA+55aFzSAPvw9eOFLkMtcfRS_EcWps6zX0L2qG=xsgq9LhFpdQ@mail.gmail.com>
Subject: Re: Linux 3.6-rc4
To: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 12:05 PM, Dave Jones <davej@redhat.com> wrote:
>
> and still in rc7.
>
> Peter ?

The fix for this should be merged in my current git tree now.

If this works out ok, we can backport them. See merge commit
94095a1fff89, which pulls the fixes and talks about it.

               Linus
