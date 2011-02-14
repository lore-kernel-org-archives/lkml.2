Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab1BNLc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:32:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59177 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1BNLcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:32:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xx128c6MmDONcicpU/ilTUy0iMGrSXs9wSumS++5RJIlvxNvsRgOcaBR2+O7LxidDh
         00pNQQdwo7YK06Wy05tLTAlfEiXckedPKQjll5Y3HoFj1/IANxGbYtnuN5g/4ZB8E9o6
         tyEJbB96X4xGpnyPODcLONvx8KQkNsntUEXc4=
Date: Mon, 14 Feb 2011 12:32:21 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk
 registration
Message-ID: <20110214113221.GG18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-16-git-send-email-tj@kernel.org>
 <4D5729A7.7070706@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5729A7.7070706@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Feb 12, 2011 at 04:45:27PM -0800, Yinghai Lu wrote:
> please don't put setup_node_bootmem calling into numa_register_memblks()
> that is not related.
> 
> put the calling in initmem_init() directly is more reasonable.

No, I don't think so.  If you don't like the function name, let's
change the name.  I think it's better to put all registrations there.
Later in the series but function is changed to deal with struct
numa_meminfo anyway so maybe it's better to rename it to
numa_register_meminfo().

Thanks.

-- 
tejun
