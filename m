Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0IEWFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 18:05:00 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23620 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0IEWE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 18:04:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=yWxzUcIADgW1lYV07Ye4RyNF/U407k9yZTZoXdAaJUBbd3NL9EALzUies63iOzvBn
	omkXKu7rdwAi+xMgZGNQg==
Date: Sun, 5 Sep 2010 15:04:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kulikov Vasiliy <segooon@gmail.com>
cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 13/14] mm: mempolicy: Check return code of check_range
In-Reply-To: <1283711588-7628-1-git-send-email-segooon@gmail.com>
Message-ID: <alpine.DEB.2.00.1009051503580.5003@chino.kir.corp.google.com>
References: <1283711588-7628-1-git-send-email-segooon@gmail.com>
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
> Function check_range may return ERR_PTR(...). Check for it.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
