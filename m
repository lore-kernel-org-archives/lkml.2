Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1HYJc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:32:58 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35824 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1HYJcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110825092045.GG3286@htj.dyndns.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
 <1314138000-2049-4-git-send-email-tj@kernel.org> <CALdu-PDAgqeRJt5vqTB9wddwz70Yn+Jf-Pb0dDKDBD_q37tHQg@mail.gmail.com>
 <20110825092045.GG3286@htj.dyndns.org>
From: Paul Menage <paul@paulmenage.org>
Date: Thu, 25 Aug 2011 02:32:35 -0700
X-Google-Sender-Auth: U0DF9qCq74h0kwhaG-64oruMWN4
Message-ID: <CALdu-PDVzDzJWmyUB4vqR5qYVbMPgtM4BE4BwC3wk5ah0VzQcw@mail.gmail.com>
Subject: Re: [PATCH 3/6] cgroup: introduce cgroup_taskset and use it in
 subsys->can_attach(), cancel_attach() and attach()
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 2:20 AM, Tejun Heo <tj@kernel.org> wrote:
>
> I think having separate ->attach() and ->attach_task() is inherently
> broken.  Look at the memcg discussion I had in this thread for
> reference and as soon as we need to do something across the tasks
> being migrated, iteration-by-callback becomes very painful.
> e.g. let's say memcg wants to find the mm->owner and wants to print
> warning or fail if that doesn't work out.  How would that be
> implemented if it's iterating by callback.

OK, fair point. See my other email for patch comments.

Paul
