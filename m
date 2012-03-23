Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab2CWPx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 11:53:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39247 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758856Ab2CWPx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 11:53:26 -0400
MIME-Version: 1.0
In-Reply-To: <4F6C170A.4070305@linux.vnet.ibm.com>
References: <20120322095502.30866.75756.sendpatchset@codeblue> <4F6C170A.4070305@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Mar 2012 08:53:04 -0700
X-Google-Sender-Auth: 6YL5vu6hVji0V6UpdjbHWigOhqc
Message-ID: <CA+55aFyOMzHJgVU4MivMnUovF7+obxBE2-paq5h+hX_vsq3wzQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] config: simplify INLINE_SPIN_UNLOCK
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Chris Zankel <chris@zankel.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 11:24 PM, Raghavendra K T
<raghavendra.kt@linux.vnet.ibm.com> wrote:
>
> Linus, Please let me know if this is what you were looking for or Did I
> really mess it up :(

Yeah, this was what I was looking for. It seems much simpler to me,
and allows the individual odd config options to just do the "select
uninline" instead of having to have some complex logic about other
config options in the inlining option itself.

                   Linus
