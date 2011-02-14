Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab1BNO6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:58:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37900 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab1BNO6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:58:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u5wvwHhAZkLOHT3/6BXgb6bm1gQFftYdy172lChG3WxBWsGQSWGz5E2J9KuZjUSPHo
         zpeE6eHE/5NAQz58YWFtYty4E6CKN/M5f8a7655gSSN6RRb2+TnJ1vTaENzz+C4b3wlk
         /+akq76BlxEgp8nxYVJ3tzfWc7eyTRf5tK4Ho=
Date: Mon, 14 Feb 2011 15:58:02 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com
Subject: Re: [PATCH UPDATED 03/26] x86, NUMA: Drop @start/last_pfn from
 initmem_init() initmem_init()
Message-ID: <20110214145802.GO18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-4-git-send-email-tj@kernel.org>
 <20110214135052.GJ18742@htj.dyndns.org>
 <20110214142011.GB27076@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214142011.GB27076@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 03:20:11PM +0100, Ingo Molnar wrote:
> You forgot to add:
> 
>   Reported-by: Yinghai Lu <yinghai@kernel.org>
> 
> The kernel development process is review and testing limited and we have a clear 
> oversupply in development power. So we want to encourage review and testing feedback 
> as much as possible, so adding all the Reported-by / Tested-by tags is absolutely 
> vital to being able to do more development.

git tree updated accordingly, but Reported-by?  I use that to identify
the person who found out the root problem the commit is addressing.
Once review cycle is complete, Reviewed/Acked-by's will be added so
I'm not sure adding Reported-by serves any purpose.

Thanks.

-- 
tejun
