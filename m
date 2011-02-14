Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab1BNTbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:31:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58957 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab1BNTbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:31:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nNXU3xq0iWcBQVulQfQ/L+FooN/864YlVnAM4N1/vL+c6xPq2W2K5Rk8ly+P5vFEU4
         HB0xitcPv0qZymqac8mYRCeuRck4iRPCgjCIXx7kW53ZoWYk507inF26YKpigCaocjbs
         IIi2FihQdpTpfwSxwPuTISDQfIg+htPxd0CC0=
Date: Mon, 14 Feb 2011 20:31:14 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, x86@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com
Subject: Re: [PATCH UPDATED 03/26] x86, NUMA: Drop @start/last_pfn from
 initmem_init() initmem_init()
Message-ID: <20110214193114.GD18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-4-git-send-email-tj@kernel.org>
 <20110214135052.GJ18742@htj.dyndns.org>
 <20110214142011.GB27076@elte.hu>
 <20110214145802.GO18742@htj.dyndns.org>
 <4D597C87.8040404@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D597C87.8040404@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:03:35AM -0800, Yinghai Lu wrote:
> initmem_init() extensively accesses and modifies global data
> structures and the parameters aren't even followed depending on which
> path is being used.  Drop @start/last_pfn and let it deal with
> @max_pfn directly.  This is in preparation for further NUMA init
> cleanups.
> 
> -v2: x86-32 initmem_init() weren't updated breaking 32bit builds.  Fixed.
>      Found by Yinghai

Alright, updated accordingly in the git tree.

Thanks.

-- 
tejun
