Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab0L2KxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 05:53:00 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:32776 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab0L2Kw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 05:52:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ot0oR9cVdgxjk3UuAPopM2C5UBC50WUH/7ZCh6kiqgn0vWpb/wcrLLOYWWhwSiyER7
         3MBBNqltyfWkfvUZSz6PUH5EjDDQT+N2gCI7FBfBxQpSeDiuVhk9rZq9WIedgZS+70Vp
         QCIqkHotZUU0I9mfjnOBlvFExRGJif3BtBHJY=
Date: Wed, 29 Dec 2010 11:52:53 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 13/16] x86: Unify cpu/apicid <-> NUMA node mapping
 between 32 and 64bit
Message-ID: <20101229105253.GK488@htj.dyndns.org>
References: <1293536929-31683-1-git-send-email-tj@kernel.org>
 <1293536929-31683-14-git-send-email-tj@kernel.org>
 <alpine.DEB.2.00.1012281231070.8883@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012281231070.8883@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 12:35:45PM -0800, David Rientjes wrote:
> This is going to conflict with a387e95a ("") in x86/numa, so you'll need 
> the following hunk for acpi_fake_nodes().  I'm not sure why this patchset 
> is being based on x86/apic-cleanup rather than x86/numa?

Because several patches from the patchset have already been committed
into x86/apic-cleanup.  Thomas, Peter, if this needs to be rebased
somewhere, let me know.

Thanks.

-- 
tejun
