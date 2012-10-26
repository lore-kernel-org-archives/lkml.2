Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549Ab2JZRon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:44:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758911Ab2JZRol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:44:41 -0400
Date: Fri, 26 Oct 2012 19:45:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 0/1] freezer: change ptrace_stop/do_signal_stop to use
	freezable_schedule()
Message-ID: <20121026174545.GA21639@redhat.com>
References: <1350426526-14254-3-git-send-email-tj@kernel.org> <20121022174404.GA21553@redhat.com> <20121022211317.GD5951@atj.dyndns.org> <20121023153919.GA16201@redhat.com> <20121024185710.GA12182@atj.dyndns.org> <20121025163941.GA3801@redhat.com> <20121025163959.GB3801@redhat.com> <20121025171812.GE11442@htj.dyndns.org> <20121025173433.GA7650@redhat.com> <20121025173632.GI11442@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025173632.GI11442@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 10/25, Tejun Heo wrote:
>
> > But! the comment above try_to_freeze() becomes misleading with
> > this patch, so this really needs v2.
>
> But, yeah, I think we should move it above relock: and update the
> comment to explain that that's the usual freezing site.

Yeeeeeeees, I knew that you won't allow me to simply remove the old
comment without adding the new one ;)

And you can't imagine how many time I spent trying to invent something
meaningful. Please feel free to update/rewrite it, I am not sure it
is good enough. Or I can send v3 if you suggest something better.

Oleg.

