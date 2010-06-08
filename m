Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0FHTFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:05:10 -0400
Received: from smtp-out.google.com ([74.125.121.35]:6076 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab0FHTFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:05:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=xbeOouG9El5nmDCkfXhCTOKXRJ8VY+63QYHg/q9mmiIjbAJKsEVBxw2LNJG6IVXRv
	qpnDA7JGHSTaEyVNu/t1w==
Date: Tue, 8 Jun 2010 12:05:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 09/10] oom: filter tasks not sharing the same cpuset
In-Reply-To: <20100608210148.7695.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006081201530.18848@chino.kir.corp.google.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com> <20100608210148.7695.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, KOSAKI Motohiro wrote:

> From: David Rientjes <rientjes@google.com>
> 
> Tasks that do not share the same set of allowed nodes with the task that
> triggered the oom should not be considered as candidates for oom kill.
> 

You're not a maintainer, as I obviously have to point out to you often 
enough.  I've repeatedly asked you to work with me in reviewing my oom 
killer rewrite on linux-mm, yet you seldom offer any valuable feedback 
other than a simple "nack".  I don't consider any of your patchset here to 
be more applicable than my patchset, which has been developed over the 
course of several months, and your lack of participation in the process is 
really quite shocking to me.

In case nobody has told you before: Andrew maintains this code and these 
patches will be going through the -mm tree.  You are not a maintainer of 
it (or any other kernel code), so please act within your role of kernel 
hacker and review patches as people propose them by offering your 
constructive feedback.
