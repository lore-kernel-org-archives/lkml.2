Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0C3MiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:38:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47527 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab0C3MiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:38:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=WvjUNP4iSphrA0+sw6dNCLxVBg+8cuetbxpNtCqP1Z6WDbaF8bd22JAPh3mFOHm2hr
         yTpAZkYEizo+QUk+L4HBmMWRxfi8h7LE3rdI++aim9jkLBk7grQpOPoGXvCK+tC3OqeY
         rAj5JDY0kdFQjmSqIdN2B1ge1/c/c9X7/sVoY=
Message-ID: <4BAFF94D.5070402@gmail.com>
Date: Mon, 29 Mar 2010 09:50:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       cl@linux-foundation.org, mingo@elte.hu, adobriyan@gmail.com,
       tglx@linutronix.de, hpa@zytor.com, yi.zhu@intel.com,
       reinette.chatre@intel.com, ilw@linux.intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCHSET] remove implicit slab.h inclusion from from percpu.h
References: <1269420538-18039-1-git-send-email-tj@kernel.org>
In-Reply-To: <1269420538-18039-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 05:48 PM, Tejun Heo wrote:
> Hello,
> 
> This is the proper patchset to break implicit slab.h inclusion from
> percpu.h.  Please refer to the last RFC posting[L] for background.
> 
> This patchset contains the following four patches.
> 
>  0001-x86-don-t-include-slab.h-from-arch-x86-include-asm-p.patch
>  0002-iwlwifi-don-t-include-iwl-dev.h-from-iwl-devtrace.h.patch
>  0003-include-cleanup-Update-gfp.h-and-slab.h-includes-to-.patch
>  0004-percpu-don-t-implicitly-include-slab.h-from-percpu.h.patch

Patch descriptions updated to include *-by's and fix some broken
sentences.  The git tree has been updated accordingly.  I'll ask
Stephen to pull it into -next soonish.  If nothing breaks too
drastically there, hopefully, Linus can pull this in.

Thanks.

-- 
tejun
