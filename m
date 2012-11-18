Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab2KRUUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 15:20:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab2KRUUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 15:20:52 -0500
Date: Sun, 18 Nov 2012 21:21:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Chris Evans <scarybeasts@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, u3557@dialix.com.au,
        security@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] ptrace: introduce PTRACE_O_EXITKILL
Message-ID: <20121118202108.GA20360@redhat.com>
References: <20121107150934.GA27606@redhat.com> <20121108062935.BFF3A592024@miso.sublimeip.com> <20121108123716.GA20917@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108123716.GA20917@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Oleg Nesterov wrote:
>
> On 11/08, Amnon Shiloh wrote:
> >
> > Thanks for the patch, I tried it and it works nicely!
>
> OK, thanks. I'll wait for other comments a bit and then send
> the patch to Andrew.

OK, nobody cares, so I am sending the same patch to Andrew.
The only change is that the new option uses (1 << 20) rather
than 16 so that we have a bit more room for the new events.

Oleg.

