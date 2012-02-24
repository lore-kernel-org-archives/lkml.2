Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2BXG5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:57:43 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38626 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962Ab2BXG5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:57:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.152.123.68 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
Date: Fri, 24 Feb 2012 08:57:37 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: David Rientjes <rientjes@google.com>
cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: add sysctl to enable slab memory dump
In-Reply-To: <alpine.DEB.2.00.1202231509510.26362@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.02.1202240856370.1917@tux.localdomain>
References: <20120222115320.GA3107@x61.redhat.com> <alpine.DEB.2.00.1202221640420.14213@chino.kir.corp.google.com> <20120223152226.GA2014@x61.redhat.com> <alpine.DEB.2.00.1202231509510.26362@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012, David Rientjes wrote:
> > Great! So, why not letting the time tell us if this feature will be obsoleted
> > or not? I'd rather have this patch obsoleted by another one proven better, than
> > just stay still waiting for something that might, or might not, happen in the
> > future.
> 
> Because (1) you're adding a sysctl that we don't want to obsolete and 
> remove from the kernel that someone will come to depend on and then have 
> to find an alternative solution like /dev/mem_notify, and (2) people parse 
> messages like this that are emitted to the kernel log that we don't want 
> to break in the future.
> 
> So NACK on this approach.

Right. We should drop the sysctl and make it into a kernel command line 
debugging option instead.

			Pekka
