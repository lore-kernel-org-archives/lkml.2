Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0DIRJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 13:09:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47794 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0DIRJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 13:09:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=PeB9SzqSCK0tCve3oXbY7XjXsKvaskaW/1QhEpcnuITwQLRECSMpShL+WZ3t4p0T+
	Yv+0HzEf4P7UPmseIA8Kw==
Date: Fri, 9 Apr 2010 10:09:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Changli Gao <xiaosuo@gmail.com>
cc: Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] flex_array: fix the panic issue when calling
 flex_array_alloc() without __GFP_ZERO
In-Reply-To: <4BBEA79A.3020307@gmail.com>
Message-ID: <alpine.DEB.2.00.1004091009030.22387@chino.kir.corp.google.com>
References: <4BBEA79A.3020307@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010, Changli Gao wrote:

> fix the panic issue when calling flex_array_alloc() without __GFP_ZERO.
> 
> memset is called with the wrong address, then kernel panics.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
