Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab2JQRd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:33:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab2JQRdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:33:55 -0400
Date: Wed, 17 Oct 2012 19:35:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/9] uprobes: allow ignoring of probe hits
Message-ID: <20121017173510.GA11019@redhat.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-3-git-send-email-rabin@rab.in> <20121015165218.GA10239@redhat.com> <CAH+eYFBHXAWTinnVO8vEnEhFDQLibwo+BtxYJJYdPcG9__n5OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH+eYFBHXAWTinnVO8vEnEhFDQLibwo+BtxYJJYdPcG9__n5OQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Rabin Vincent wrote:
>
> 2012/10/15 Oleg Nesterov <oleg@redhat.com>:
> >
> > Not sure I understand why we shouldn't call handlers in this case,
> > but OK, I know nothing about arm.
>
> This old discussion about kprobes should be useful:
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2011-March/045755.html

Thanks... Not sure I understand this discussion...

And, to clarify, I am not arguing. Just curious.

So, is this like cmov on x86? And this patch allows to not report if
the condition is not true? Or there are other issues on arm?

Oleg.

