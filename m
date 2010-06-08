Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0FHTBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:01:49 -0400
Received: from smtp-out.google.com ([74.125.121.35]:4624 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab0FHTBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:01:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=dWSBJTv/TVxN0oZ9a57Gxq8daRJE8s6Vin9fS8nj1lZbArS747gopHH80pQ5TxxwX
	vUse450wioaqy1qY0CHQw==
Date: Tue, 8 Jun 2010 12:01:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 07/10] oom: kill useless debug print
In-Reply-To: <20100608205909.768F.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006081201100.18848@chino.kir.corp.google.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com> <20100608205909.768F.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, KOSAKI Motohiro wrote:

> Now, all of oom developers usually are using sysctl_oom_dump_tasks.
> Redundunt useless debug print can be removed.
> 

This is already removed with my heuristic rewrite as you well know, why 
are you constantly trying to get in the way of that work?
