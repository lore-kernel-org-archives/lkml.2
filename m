Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1HXB5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:57:49 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48802 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab1HXB5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:57:43 -0400
Date: Tue, 23 Aug 2011 18:57:39 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 4/6] cgroup: don't use subsys->can_attach_task() or
 ->attach_task()
Message-ID: <20110824015739.GE28444@count0.beaverton.ibm.com>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
 <1314138000-2049-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314138000-2049-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:19:58AM +0200, Tejun Heo wrote:

<snip>

> * In cgroup_freezer, remove unnecessary NULL assignments to unused
>   methods.  It's useless and very prone to get out of sync, which
>   already happened.

You could post this part independently -- that might be best since
I guess the taskset bits will need more discussion.

Cheers,
	-Matt Helsley
