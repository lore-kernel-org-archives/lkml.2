Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab0FHTHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:07:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35058 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab0FHTHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:07:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=HYVsXHox1q2wEbJ7OcYnH+w9e8DilnNRuNlaeJgtfU2oPkK3TcKMBCvm+RUxfQmw7
	86t0c4GHj3abbgmmVQ/pA==
Date: Tue, 8 Jun 2010 12:07:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 06/10] oom: cleanup has_intersects_mems_allowed()
In-Reply-To: <20100608205829.768C.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006081206090.23776@chino.kir.corp.google.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com> <20100608205829.768C.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, KOSAKI Motohiro wrote:

> Now has_intersects_mems_allowed() has own thread iterate logic, but
> it should use while_each_thread().
> 
> It slightly improve the code readability.
> 

These cleanups should be done on top of my oom killer rewrite instead, 
please work with others in their work instead of getting in the way of it 
time and time again.
