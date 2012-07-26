Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137Ab2GZE6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 00:58:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59393 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2GZE6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 00:58:38 -0400
Date: Thu, 26 Jul 2012 10:28:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] uprobes: introduce vaddr_to_offset(vma, vaddr)
Message-ID: <20120726045827.GA3810@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120712170934.GA25455@redhat.com>
 <20120712171017.GA25497@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120712171017.GA25497@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072604-2356-0000-0000-000000B234E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-07-12 19:10:17]:

> Add the new helper, vaddr_to_offset(vma, vaddr) which returns the
> offset in vma->vm_file this vaddr is mapped at.
> 
> Change build_probe_list() and find_active_uprobe() to use the new
> helper, the next patch adds another user.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

