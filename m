Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397Ab1CDKQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:16:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60532 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144Ab1CDKQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:16:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IeguddlNo2ioSWQ9YSizEARvj+Vuxd2C9XLvWGBBZhnVVLzoru7R1wPbqE/Rcdsrn1
         neV960CT7JoksKU0sPHT+YdVWSt2olITndn3jPc+5lsBpo9k/WI/NtooCXLaaOGaGexq
         WZpuN6zD5JLqcfJHlrxwB9V14F4FeM6+PoRIg=
Date: Fri, 4 Mar 2011 11:16:32 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Clean up initmem_init
Message-ID: <20110304101620.GG20499@htj.dyndns.org>
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org>
 <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com>
 <20110221083511.GC31267@htj.dyndns.org>
 <alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 03, 2011 at 01:15:04PM -0800, David Rientjes wrote:
> This patch cleans initmem_init() so that it is more readable and doesn't
> use an unnecessary array of function pointers to convolute the flow of
> the code.  It also makes it obvious that dummy_numa_init() will always
> succeed (and documents that requirement) so that the existing BUG() is
> never actually reached.
> 
> No functional change.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Just a nitpick.

> +/*
> + * Used if there's no underlying NUMA architecture, NUMA initialization fails,
> + * or NUMA is disabled on the command line.
> + *
> + * Must online at least one node and add memory blocks that cover all allowed
> + * memory.
> + */

Can you please reformat to docbook style?

Thanks.

-- 
tejun
