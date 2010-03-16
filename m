Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab0CPVmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:42:43 -0400
Received: from smtp-out.google.com ([74.125.121.35]:41236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab0CPVml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:42:41 -0400
X-Greylist: delayed 833 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2010 17:42:39 EDT
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Q/QpA85xJaQIFIiYMFSYVSCzp7tgWV6aQfuKlWs9+dXp1PLVm4TS4LD4nzOcLbh7t
	52DIJtl8CLtnF2IMSybgA==
Date: Tue, 16 Mar 2010 14:26:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [RESEND][PATCH 2/2] cpuset: alloc nodemask_t at heap not stack
 (v2)
In-Reply-To: <4B9F759C.8090300@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1003161426050.10930@chino.kir.corp.google.com>
References: <4B9F759C.8090300@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010, Miao Xie wrote:

> Allocating nodemask_t at heap instead of stack.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
