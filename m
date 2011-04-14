Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab1DNOuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:50:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59344 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022Ab1DNOuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g3m8s7NzgcLkQMdAH1KpGouifgDsZbmNGHH9AraNAtdLp+iz2G9KizatGeFbf8LpA6
         5run9qqpb85opLua6heM2jgFQ00seYJ20/p2KEBM+u6UQ256nu2ZfonWRgudrqc2hLpg
         zU7r8wORze1gmB+Tlm9NnILYyV8VX+MC7usKg=
Date: Thu, 14 Apr 2011 23:49:51 +0900
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Brian Gerst <brgerst@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        David Rientjes <rientjes@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86-64, NUMA: fix fakenuma boot failure
Message-ID: <20110414144951.GB21397@mtj.dyndns.org>
References: <20110412153212.B514.A69D9226@jp.fujitsu.com>
 <20110412071318.GA10425@mtj.dyndns.org>
 <20110413160239.D72A.A69D9226@jp.fujitsu.com>
 <20110413193219.GF3987@mtj.dyndns.org>
 <20110414064414.GA15535@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414064414.GA15535@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 14, 2011 at 08:44:14AM +0200, Ingo Molnar wrote:
> Hm, the patch is whitespace clean and applies without fuzz here. Are
> you sure you processed it the right way?

Hmmm... it went through my usual mutt -> mbox -> mbox2patches sequence
and I got a corrupted patch, so I assumed the original was corrupt but
it seems something in my chain is broken.  Sorry about the noise.

-- 
tejun
