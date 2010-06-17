Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101Ab0FQESu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 00:18:50 -0400
Received: from smtp-out.google.com ([74.125.121.35]:16720 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab0FQESt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 00:18:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=JvqKE7qEcJf+KXonsYSAbrCrCln+LixYJe3mlYME8Ab/7NIRKnshmwUT38hFgi+0D
	lRvPL54W8bO6IN6aFpGRg==
Date: Wed, 16 Jun 2010 21:18:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/9] oom: unify CAP_SYS_RAWIO check into other superuser
 check
In-Reply-To: <20100617104756.FB8F.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006162118160.14101@chino.kir.corp.google.com>
References: <20100617104311.FB7A.A69D9226@jp.fujitsu.com> <20100617104756.FB8F.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, KOSAKI Motohiro wrote:

> 
> Now, CAP_SYS_RAWIO check is very strange. if the user have both
> CAP_SYS_ADMIN and CAP_SYS_RAWIO, points will makes 1/16.
> 
> Superuser's 1/4 bonus worthness is quite a bit dubious, but
> considerable. However 1/16 is obviously insane.
> 

This is already obsoleted by the heuristic rewrite that is already under 
review.
