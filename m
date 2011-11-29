Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1K2TjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:39:05 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34223 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab1K2TjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:39:02 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain> <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 Nov 2011 11:38:40 -0800
X-Google-Sender-Auth: FiQQZbDjC0ccDf_TLqp9OVJhJ6Y
Message-ID: <CA+55aFxsomMUqgyseZVunbbOUMXtfHGm1jkGhfeCd29zUrABsQ@mail.gmail.com>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
To: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 11:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Dammit, the emulation is just bad.

Btw, wasn't the "crazy random thiscpu ops" one of the topics at the
KS? I thought we agreed to clean these things up and remove most of
them? Did it just get dropped, or is it pending somwhere?

              Linus
