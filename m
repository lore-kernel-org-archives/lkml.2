Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290Ab2CWAh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 20:37:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34853 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2CWAhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 20:37:25 -0400
MIME-Version: 1.0
In-Reply-To: <4F6BC1C4.6050502@zytor.com>
References: <1332459220.16101.144.camel@sbsiddha-desk.sc.intel.com>
 <CA+55aFyf9RqAROx7t=CYUSGCDBXvv9z2c+LP1vRJjLU45_pD+Q@mail.gmail.com>
 <1332460885.16101.147.camel@sbsiddha-desk.sc.intel.com> <4F6BC1C4.6050502@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Mar 2012 17:37:03 -0700
X-Google-Sender-Auth: 6gYt-fcxejYVNVvwz9gX8eADQT0
Message-ID: <CA+55aFygUGmL0iCKYn5DBitrPSm0GHZ8e5j0j2OzcBcAkUMiFw@mail.gmail.com>
Subject: Re: [patch] x86, tlb: switch cr3 in leave_mm() only when needed
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 5:20 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Looks great to me.  Linus, do you want this one later in the window if
> it tests out OK between now and then, or is it too late?

It's small and trivial, so it's fine. I *would* like to hear whether
it actually makes any real difference, though. I do see "intel_idle()"
as a big cost in idle profiles, and I assume that translates to power
use too, but if you guys have some actual numbers, that would be even
better.

                   Linus
