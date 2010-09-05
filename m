Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0IEWAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 18:00:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0IEWAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 18:00:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CxmAgnV9OQQ2jhKe0SDV5a8pkypyVq2tdhiwIPym2IvSzrXCIZ2f5RPvU7gpQHuum
	y7TPp1WKoOAorNsfbnb9Q==
Date: Sun, 5 Sep 2010 15:00:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kulikov Vasiliy <segooon@gmail.com>
cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 14/14] mm: oom_kill: use IS_ERR() instead of strict
 checking
In-Reply-To: <1283711592-7669-1-git-send-email-segooon@gmail.com>
Message-ID: <alpine.DEB.2.00.1009051500200.5003@chino.kir.corp.google.com>
References: <1283711592-7669-1-git-send-email-segooon@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Sep 2010, Kulikov Vasiliy wrote:

> From: Vasiliy Kulikov <segooon@gmail.com>
> 
> Use IS_ERR() instead of strict checking.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
