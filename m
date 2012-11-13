Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab2KMBKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:10:30 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56030 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab2KMBK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:10:29 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1211121339000.23347@chino.kir.corp.google.com>
References: <545706980.41498.1352739027798.JavaMail.mail@webmail19> <alpine.DEB.2.00.1211121339000.23347@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Nov 2012 17:10:07 -0800
X-Google-Sender-Auth: CRPolDe77re9r_3Qb5U5RSUCzq0
Message-ID: <CA+55aFz2Kgn0mVV4ozH0g1QGKw1VE6NpgCz9taxxfbCUz2a8VA@mail.gmail.com>
Subject: Re: OOM changes in Linux 3.7 lead to udev warnings and total breakage
 of KDE 3.5.10/TDE
To: David Rientjes <rientjes@google.com>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <dave@gnu.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 1:41 PM, David Rientjes <rientjes@google.com> wrote:
>
> This is
> http://mail.kde.org/pipermail/unassigned-bugs/2010-December/016850.html
> from almost two years ago.  The tunable had been on the feature removal
> schedule for two years and would have emitted a warning if you had run on
> any kernel during that time.  KDE 4.6.1 and later from two years ago work
> fine.

Doesn't matter. If something breaks real users, it needs to get
reverted (or worked around).

The feature-removal.txt file was a joke, and was used as an excuse for
exactly the above kind of bad behavior. It got removed for good
reasons.

The work-around might be as simple as creating an oom_adj file that
simply doesn't do anything.

               Linus
