Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab0LVNRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:17:25 -0500
Received: from mail-bw0-f67.google.com ([209.85.214.67]:60307 "EHLO
	mail-bw0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab0LVNRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:17:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LnTkGf/e2zg2MtWtnges/FV1lFopo+9R5Tw9XqwP6CbB64TumRftRczkyOVsST3s0U
         MF2e0YweLWp3V3YzGfUnDz/hoEM1SytvhD/lf4R9NIFfytuKikvepmtI2/C7oT6ecfm7
         KkktxR60Bj84yRKkLydEY+kxyVinPR7/5/DeU=
Date: Wed, 22 Dec 2010 14:17:19 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Len Brown <lenb@kernel.org>,
        Jack Steiner <steiner@sgi.com>, Lori Gilbertson <loriann@sgi.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Early kernel messages are overflowing the static log buffer
Message-ID: <20101222131719.GA8061@htj.dyndns.org>
References: <4D06B317.2090608@sgi.com>
 <20101222130946.GC13412@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101222130946.GC13412@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 22, 2010 at 02:09:46PM +0100, Ingo Molnar wrote:
> > [    0.000000] pcpu-alloc: [000] 0000 0001 0002 0003 0004 0005 0006 0007 1024 1025 1026 1027 1028 1029 1030 1031
> > 
> > What I'm asking is which of these would be most acceptable to
> > either remove or replace with some sort of message reduction?
> 
> The pcpu alloc messages look entirely superfluous and zappable - make them 
> KERN_DEBUG perhaps (and Cc: Tejun)?

Yeap, with percpu allocator now mostly stable, I don't think the
message needs to be KERN_INFO anymore.  I'll change it to KERN_DEBUG.

Thanks.

-- 
tejun
