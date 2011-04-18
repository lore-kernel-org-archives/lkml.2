Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab1DRRlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:41:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726Ab1DRRlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:41:31 -0400
MIME-Version: 1.0
In-Reply-To: <20110418173224.GA27918@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Apr 2011 10:40:40 -0700
Message-ID: <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/7] signal: sigprocmask fixes
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:32 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> These patches should not change the current behaviour in this case.
> We never try to re-target the thread-specific signals. Note that
> retarget_shared_pending() checks ->signal->shared_pending only.

Ok, I clearly didn't follow the details closely enough.

In that case, this series looks fairly ok to me. I'm still unsure
whether it's _required_, but it looks sane and reasonable.

                   Linus
