Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1AYN2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:28:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37209 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1AYN2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:28:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RyIH+zle3sy4FEjf7SfVK+hLl70otlfh78gH8wcU4GV741HRCQ7p6z4Qnst1iNThD8
         +uu55WFj7/2208qQpP0w5Aef+p4i9CJCU6YEAp/b7cP73h5jIHIvxrDVKslPjG+BexAA
         zd6NBbHEOml5irOoex/1mq3OxFye+H166MJG4=
Date: Tue, 25 Jan 2011 14:28:37 +0100
From: Tejun Heo <tj@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, eric.dumazet@gmail.com,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] alpha: use L1_CACHE_BYTES for cacheline size in the
 linker script
Message-ID: <20110125132837.GU27510@htj.dyndns.org>
References: <20101227133719.GD488@htj.dyndns.org>
 <20101227204309.GA3878@merkur.ravnborg.org>
 <20101228111822.GF488@htj.dyndns.org>
 <20101228113345.GG488@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101228113345.GG488@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 12:33:45PM +0100, Tejun Heo wrote:
> Currently the linker script uses 64 for cacheline size which isn't
> optimal for all cases.  Include asm/cache.h and use L1_CACHE_BYTES
> instead as suggested by Sam Ravnborg.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>

applied to percpu#for-2.6.39.

Thanks.

-- 
tejun
