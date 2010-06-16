Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab0FPVk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:40:59 -0400
Received: from smtp-out.google.com ([74.125.121.35]:34304 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab0FPVk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:40:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=QlL23hYmmOBG5Fe2VMW77j7v9prJGZz8TVdDQPzYoVHUXzbEmTMDQqf17WhtPIh4H
	wZKZYQPlmFcgV1xupBYWw==
Date: Wed, 16 Jun 2010 14:40:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/9] oom: rename badness() to oom_badness()
In-Reply-To: <20100616202920.72DA.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006161440360.11089@chino.kir.corp.google.com>
References: <20100616201948.72D7.A69D9226@jp.fujitsu.com> <20100616202920.72DA.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010, KOSAKI Motohiro wrote:

> 
> badness() is wrong name because it's too generic name. rename it.
> 

This is already done in my badness heuristic rewrite, can we please focus 
on its review?
