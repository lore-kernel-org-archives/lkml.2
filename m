Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1CWHZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:25:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45321 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1CWHZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UruZrVOD/LQCB0IFTFGclOdZeauIrWutslnwIXekyom7c4qveBhd193nMkdcZIYTGe
         Rd2OV17cqLGD/IPni8CGWf8fvjSjEpKXzXP3GgvkqdOIrJ8MqDfgscFgr/VlvUfN3hVi
         irBzuSxD73kPnuOrO4rwE84VTEwT624psGgzo=
Date: Wed, 23 Mar 2011 08:25:24 +0100
From: Tejun Heo <tj@kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: cast away printk format warning
Message-ID: <20110323072524.GT12003@htj.dyndns.org>
References: <1300826388-22881-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300826388-22881-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 04:39:48PM -0400, Mike Frysinger wrote:
> On 32-bit systems which don't happen to implicitly define or cast
> VMALLOC_START and/or VMALLOC_END to long in their arch headers, the
> printk in the percpu code will cause a warning to be emitted:
> 
> mm/percpu.c: In function 'pcpu_embed_first_chunk':
> mm/percpu.c:1648: warning: format '%lx' expects type 'long unsigned int',
> 	but argument 3 has type 'unsigned int'
> 
> So add an explicit cast to unsigned long here.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied to percpu:fixes-2.6.39 with slight reformatting to avoid going
over 80 column.

Thanks.

-- 
tejun
