Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1BTBw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 20:52:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1BTBv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 20:51:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=YKI5lGiPZGwCc2D0hxUn8sesMlg9LfJS6ablRyYD53J3NEL4QBpnZJTnHrxX/NshVp
         LwAMP9fktGfheIABuerQ==
Date: Sat, 19 Feb 2011 17:51:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        miaox@cn.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] cpuset: Remove unneeded NODEMASK_ALLOC() in
 cpuset_sprintf_memlist()
In-Reply-To: <4D5C7EA7.1030409@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1102191739200.27722@chino.kir.corp.google.com>
References: <4D5C7EA7.1030409@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011, Li Zefan wrote:

> It's not necessary to copy cpuset->mems_allowed to a buffer
> allocated by NODEMASK_ALLOC(). Just pass it to nodelist_scnprintf().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
