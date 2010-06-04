Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0FDMHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 08:07:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45551 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab0FDMH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 08:07:28 -0400
Subject: Re: [PATCH UPDATED 2/4] sched: adjust when cpu_active and cpuset
 configurations are updated during cpu on/offlining
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       paulus@samba.org, acme@redhat.com, Paul Menage <menage@google.com>
In-Reply-To: <4C08EB74.8070300@kernel.org>
References: <1275332199-28082-1-git-send-email-tj@kernel.org>
	 <1275332199-28082-3-git-send-email-tj@kernel.org>
	 <1275407846.27810.27627.camel@twins>  <4C053C39.9070405@kernel.org>
	 <1275412835.27810.27887.camel@twins>  <4C0680DB.9010503@kernel.org>
	 <1275652701.27810.39745.camel@twins>  <4C08EB74.8070300@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Jun 2010 14:07:37 +0200
Message-ID: <1275653257.27810.39763.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 14:03 +0200, Tejun Heo wrote:
> On 06/04/2010 01:58 PM, Peter Zijlstra wrote:
> >> * Rollback on failure.
> >>
> >> * cpuset/sched_domain don't expect to be called before smp
> >>   configuration is complete.  If hardcoded into cpu_up/down(),
> >>   condition checks need to be added so that they're skipped if the
> >>   system is bringing up the cpus for the first time.
> >>
> >> Works fine here w/ CPUSET enabled and disabled.
> > 
> > OK, this looks good. 
> 
> Cool, can I add your acked-by's to and send them towards Ingo?

Yes.
