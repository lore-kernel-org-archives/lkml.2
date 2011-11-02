Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1KBXXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:23:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65419 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab1KBXXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:23:20 -0400
Message-ID: <4EB1D0E2.6070909@gmail.com>
Date: Wed, 02 Nov 2011 17:23:14 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH] event: fix TP_printk() argument in sched_switch
References: <1320273611-2463347-1-git-send-email-avagin@openvz.org> <1320275277.4793.54.camel@gandalf.stny.rr.com>
In-Reply-To: <1320275277.4793.54.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2011 05:07 PM, Steven Rostedt wrote:
> This is a perf userspace bug, not a kernel one. Please fix the userspace
> tool instead.
> 
> Note, the new version of libparsevent handles this case without issue.
> Perf just needs to be updated.

I dare ask..... has any progress been made on that front? ie., with
respect to lib names and locations within the tools dir.

David

> 
> -- Steve
> 
