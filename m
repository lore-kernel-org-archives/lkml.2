Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965667Ab2JZSBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:01:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965545Ab2JZSBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:01:14 -0400
Date: Fri, 26 Oct 2012 20:01:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] freezer: change ptrace_stop/do_signal_stop to
	use freezable_schedule()
Message-ID: <20121026180149.GA22421@redhat.com>
References: <20121023153919.GA16201@redhat.com> <20121024185710.GA12182@atj.dyndns.org> <20121025163941.GA3801@redhat.com> <20121025163959.GB3801@redhat.com> <20121025171812.GE11442@htj.dyndns.org> <20121025173433.GA7650@redhat.com> <20121025173632.GI11442@htj.dyndns.org> <20121026174545.GA21639@redhat.com> <20121026174606.GB21639@redhat.com> <20121026175258.GV11442@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026175258.GV11442@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26, Tejun Heo wrote:
>
>  Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

> Rafael, sorry that this one doesn't have pm cc'd

Ah, sorry Rafael. Yes, I have read you email, and I was going to
add linux-pm but forgot.

> but can you please
> pick up this one too?

Please, and thanks.

Oleg.

