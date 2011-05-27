Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163Ab1E0Evz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:51:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53835 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1E0Evy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KYpwneDLGhItWZs51mTPSr7Hvf60WUpHbxt0rMrXI5bNiLB1ZC4H2cu4rPwUsQQTYY
         6szri21dfgzJN/mOrWC4TYlk2nHUn5I4aIjzWUifgo9CAdgwmM5wDvph6flv636MXZ5J
         2Vf0hnQ+P9bgRTxyuZJgCECO84d4M0KGxpff0=
Date: Fri, 27 May 2011 07:51:56 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: + sysctl-add-proc_dointvec_unsigned-handler.patch added to -mm
 tree
Message-ID: <20110527045156.GA2442@p183.telecom.by>
References: <201103072305.p27N5hKT000474@imap1.linux-foundation.org>
 <20110307232655.GA7234@p183.telecom.by>
 <AANLkTi=-PcbpBjWZuno1fjwZD-tGmC+JMxrzMr1FNwu7@mail.gmail.com>
 <AANLkTikxbAfpHCWzvLscdHccOju=Q1tN0pvcu_=jbeQ_@mail.gmail.com>
 <20110308082409.GA4913@p183.telecom.by>
 <AANLkTik2qpLnxUfD9NyPFSbO5PyYFeRv8cM=Nz1t=UOZ@mail.gmail.com>
 <20110308090247.GA20281@p183.telecom.by>
 <AANLkTi=Y32JLeuwagvAsuRg61VHEPQqpReot8ndcajrP@mail.gmail.com>
 <20110526125918.ba161d6f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526125918.ba161d6f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 12:59:18PM -0700, Andrew Morton wrote:
> 
> So... where did we end up with this discussion?
> 
> There are four patches involved:

> http://userweb.kernel.org/~akpm/mmotm/broken-out/sysctl-add-proc_dointvec_unsigned-handler.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/sysctl-use-proc_dointvec_unsigned-where-appropriate.patch

This still sucks:
* .extra2 aka max is ignored(!)
* even if not ignored, API can't be used on array, because min and max
  boundaries should match wrt length.
