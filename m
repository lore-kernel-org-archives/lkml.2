Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab1BNS10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:27:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51615 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1BNS1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=II/AZRSboKQ7DzD5uVC0KNPXPb7l3QZUvFXbuuMdhOVjQZCghBZAYn1irFtt4HUSxw
         SHhlMkGkChaf8SF9kyv4r+mhLmuSZHPeGrwtyHOCN6XrgGh8NQUgSw+zPxxIrDplXAX/
         j5Isa0fPQ2JZpA7tQi6X16ctvqxeSpTCCedPo=
Date: Mon, 14 Feb 2011 19:27:18 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk
 registration
Message-ID: <20110214182718.GB18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-16-git-send-email-tj@kernel.org>
 <4D5729A7.7070706@kernel.org>
 <20110214113221.GG18742@htj.dyndns.org>
 <AANLkTin0C2AhtHm6K0av2N4pQxLvK_Fc+4w12Qg_QRkZ@mail.gmail.com>
 <20110214161249.GV18742@htj.dyndns.org>
 <AANLkTim8vaDDbdAK3Q2+LNOcYsH+VbpG+XUdD6wggNfL@mail.gmail.com>
 <20110214162247.GX18742@htj.dyndns.org>
 <AANLkTi=1xKqmedFqHPgDR32OrmNXg-T34NFo8qEnymfp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=1xKqmedFqHPgDR32OrmNXg-T34NFo8qEnymfp@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 14, 2011 at 10:14:15AM -0800, Yinghai Lu wrote:
> I just want seperate setup_bootmem  ( and maybe init_memory_mapping_high...)
> out  that __register__ function.
> 
> that __register__ function do some sth like memblock_register to
> early_node_map[] looks reasonable.

Can you please provide some rationales _why_ you think setup_bootmem()
should be moved elsewhere?  Because it is not apparent to me and I
cannot read your mind.  I'm not against it given good enough reasons.
After all, _technically_ it doesn't make one iota of difference, but I
don't want to change it just because you don't like it and I don't
think you want that either, so _please_ give me some explanations
about what you want and _why_.  It's not like we're involved in a
romantic relationship and even when I'm in one I suck at that implied
communication thing.

Thanks.

-- 
tejun
