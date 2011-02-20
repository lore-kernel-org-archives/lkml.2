Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab1BTBvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 20:51:42 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46691 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab1BTBvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 20:51:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=v3LB60P6mj8fow7m+JaHj4RPBevUqtWfcSP9LlVjWl2xx/UqF5uK4NM4mXUQrdMM4p
         QUMey/Jv2Wvo7EQAVr4w==
Date: Sat, 19 Feb 2011 17:51:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        miaox@cn.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] cpuset: Hold callback_mutex in cpuset_clone()
In-Reply-To: <4D5C7F00.2050802@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1102191748400.27722@chino.kir.corp.google.com>
References: <4D5C7EA7.1030409@cn.fujitsu.com> <4D5C7F00.2050802@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011, Li Zefan wrote:

> Chaning cpuset->mems/cpuset->cpus should be protected under
> callback_mutex.
> 
> cpuset_clone() doesn't follow this rule. It's ok because it's
> called when creating and initializing a cgroup, but we'd better
> hold the lock to avoid subtil break in the future.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
