Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1C1Qsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:48:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab1C1Qsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:48:36 -0400
Date: Mon, 28 Mar 2011 17:39:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110328153926.GA6574@redhat.com>
References: <1301153868.2250.359.camel@laptop> <20110326161346.GA18272@redhat.com> <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com> <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins> <20110328151511.GA3608@redhat.com> <1301329663.4859.32.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301329663.4859.32.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Peter Zijlstra wrote:
>
> On Mon, 2011-03-28 at 17:15 +0200, Oleg Nesterov wrote:
>
> > Could you answer another question? It is not immediately clear why
> > ctx_sched_in() does not check nr_active != 0
>
> nr_active counts the number of events that have been scheduled in

OOPS! indeed, can't understand what I was thinking about...

Thanks.

Oleg.

