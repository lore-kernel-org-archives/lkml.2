Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab1EIX0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:26:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755129Ab1EIX0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:26:15 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTiksgtgviJGmq925OtLNU4QynVLVtg@mail.gmail.com>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz>
 <alpine.LSU.2.00.1105081303540.16151@sister.anvils> <alpine.DEB.2.00.1105091307570.32299@artax.karlin.mff.cuni.cz>
 <BANLkTinCUQSjjif3op3H_9HDm5Eu-o+Luw@mail.gmail.com> <BANLkTim3kKJkisZK1mOgKhsEEs7FzZmyXA@mail.gmail.com>
 <1304979549.4865.56.camel@mulgrave.site> <BANLkTim7ATRyJ2NvoCj4Sv=7CLizKMd_WA@mail.gmail.com>
 <BANLkTi=DCKmN_BafFckKHOMfjWpVLQPDFA@mail.gmail.com> <BANLkTikkA5H2D23u23FV0cTcL2bAT8BKWQ@mail.gmail.com>
 <BANLkTikLJPCc5ffobAb5uhdryRqjGhpVAQ@mail.gmail.com> <BANLkTiksgtgviJGmq925OtLNU4QynVLVtg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 May 2011 16:25:23 -0700
Message-ID: <BANLkTikUyUpa9-ZZBquHW4xSCEj8W8TgnA@mail.gmail.com>
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
To: Tony Luck <tony.luck@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Fenghua Yu <fenghua.yu@intel.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 4:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ok, I'll consider it tested. I'll commit it with Mikulas as author,
> but note that I edited it so he won't get the blame if there's some
> problem.

Oh, and I marked it for stable too, although I don't know if any
distribution really cares about parisc or ia64. And I'm not sure that
ia64 even saw the lvm2 failure case - I'd have expected to hear about
it if it actually happens there.

                       Linus
