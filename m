Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab1LUJ5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 04:57:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab1LUJ5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 04:57:12 -0500
Date: Wed, 21 Dec 2011 10:57:03 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCHv2 02/10] ftrace: Change mcount call replacement logic
Message-ID: <20111221095703.GB1726@m.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-3-git-send-email-jolsa@redhat.com>
 <1324409949.5916.78.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324409949.5916.78.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 02:39:09PM -0500, Steven Rostedt wrote:
> On Mon, 2011-12-05 at 18:22 +0100, Jiri Olsa wrote:

SNIP

>           <idle>-0     [001] ...1    13.258665: __schedule <-schedule
>           <idle>-0     [001] ...1    13.258665: add_preempt_count <-__schedule
>           <idle>-0     [001] ...2    13.258665: rcu_note_context_switch <-__schedule
>           <idle>-0     [001] ...2    13.258665: rcu_utilization: Start context switch
> 
> I'll put this to the front of my patch queue and also add it to urgent.
> I'll also rewrite your change log to remove the reference to the global

ok, I'll send new version without this one

thanks,
jirka
