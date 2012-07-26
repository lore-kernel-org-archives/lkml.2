Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab2GZFAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 01:00:32 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58995 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2GZFAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 01:00:31 -0400
Date: Thu, 26 Jul 2012 10:30:18 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] uprobes: rename vma_address() and make it return
 "unsigned long"
Message-ID: <20120726050018.GD3810@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120712170934.GA25455@redhat.com>
 <20120712171022.GA25507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120712171022.GA25507@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072605-4242-0000-0000-0000026FC179
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-07-12 19:10:22]:

> 1. vma_address() returns loff_t, this looks confusing and this is
>    unnecessary after the previous change. Make it return "ulong",
>    all callers truncate the result anyway.
> 
> 2. Its name conflicts with mm/rmap.c:vma_address(), rename it to
>    offset_to_vaddr(), this matches vaddr_to_offset().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

