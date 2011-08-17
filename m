Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab1HQPOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 11:14:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab1HQPOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 11:14:25 -0400
Date: Wed, 17 Aug 2011 17:11:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 3/3] coredump_wait: don't call complete_vfork_done()
Message-ID: <20110817151103.GA18647@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110729192358.GB31717@mtj.dyndns.org> <20110812175550.GA7484@redhat.com> <20110812175646.GD7484@redhat.com> <20110817075052.GJ4254@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817075052.GJ4254@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Tejun Heo wrote:
>
> Yeap, looks pretty good to me.  For all three patches,
>
>   Acked-by: Tejun Heo <tj@kernel.org>

Great, thanks.

Since Linus doesn't object, I hope he agrees with these changes too,

I am going to add this into ptrace branch.

Oleg.

