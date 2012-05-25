Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab2EYMrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 08:47:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:60787 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2EYMrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 08:47:39 -0400
Subject: Re: remove repeat implementation of page_referenced
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
In-Reply-To: <1337949430-24626-1-git-send-email-liwp.linux@gmail.com>
References: <1337949430-24626-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 14:47:33 +0200
Message-ID: <1337950053.9783.190.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 20:37 +0800, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> page_referenced function just called from mm/vmscan.c to handle paging
> out.It is realized in mm/rmap.c and has an interface exported in rmap.h.

I think you'll find you've broken CONFIG_MMU=n builds with this.


