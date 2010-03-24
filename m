Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0CXQE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:04:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab0CXQE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:04:26 -0400
Date: Wed, 24 Mar 2010 17:02:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm]
	signals-clear-signal-tty-when-the-last-thread-exits.fix
Message-ID: <20100324160242.GA32557@redhat.com>
References: <20100319184020.GA519@redhat.com> <20100324142348.GA8117@redhat.com> <20100324074149.8d4e96e6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324074149.8d4e96e6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Andrew Morton wrote:
>
> > -	struct tty_struct *tty;
> > +	struct tty_struct *tty = NULL;	/* supress gcc warning */
>
> uninitialized_var() is a neater way.

Aha, indeed.

Will resend soon...

Oleg.

