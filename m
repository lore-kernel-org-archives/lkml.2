Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab1CVVI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:08:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab1CVVIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:08:23 -0400
Date: Tue, 22 Mar 2011 21:59:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [RFC PATCHSET] ptrace,signal: Fix notifications to the real
	parent while ptraced
Message-ID: <20110322205908.GA3585@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <20110322131131.GS12003@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322131131.GS12003@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Tejun Heo wrote:
>
> Hello, Oleg.
>
> The updated patches should address the issues pointed out in your
> reviews, at least the ones which are appropriate to address now.

Yes, thanks. "UPDATED" patches look fine. Please feel free to add my
reviewed-by to the whole series.

I'd only ask you to remove ->group_leader from real_parent_is_ptracer()
(btw, note that wait_consider_task() can use this helper too) although
this is minor.

> Please let me know when you want the whole series resent.

Cough. Resent? If you ask me, I think you should just send them to
Linus while the merge window is opened.

I am trying to get the account on kernel.org, but until then I hope
you can flush the pending ptrace-review branches.



In case I misunderstood you... I think that the whole series is good
and the patches should not be updated. Just for example, I'd like to
rename real_parent_is_ptracer (and remove ->group_leader), but we can
make another patch for that.

And yes, I bet we missed something and we will need the subsequent
fixes anyway ;)

Oleg.

