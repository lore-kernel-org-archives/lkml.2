Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab1BTBw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 20:52:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46646 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab1BTBvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 20:51:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=P6ABjewDC+ECWVOcOuoX2ysHq4f1E4aBpiXnjGlbDcoA6iW3bHe2RShvcqXpG6NWVp
         OkcLt9eiT8vydDcoFd2w==
Date: Sat, 19 Feb 2011 17:51:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        miaox@cn.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] cpuset: Remove unneeded NODEMASK_ALLOC() in
 cpuset_attch()
In-Reply-To: <4D5C7EBF.2070603@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1102191741270.27722@chino.kir.corp.google.com>
References: <4D5C7EA7.1030409@cn.fujitsu.com> <4D5C7EBF.2070603@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011, Li Zefan wrote:

> oldcs->mems_allowed is not modified during cpuset_attch(), so
> we don't have to copy it to a buffer allocated by NODEMASK_ALLOC().
> Just pass it to cpuset_migrate_mm().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
