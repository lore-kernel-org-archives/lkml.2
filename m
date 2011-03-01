Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1CAIaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:30:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34017 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab1CAIaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:30:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YdTTmDLFuFnbMMzYMC+9ZcUur9QUN8wxsDFBB1bf4Ptm8+k7YoyhYLCdMGKQTvUziC
         bIiD3NqKgQtOMIjlGmc9+KOINg9nToftFa/DtRoScfVD2WQkvIQIz4cFomfetGybOqRm
         P139R9hEoPULgpDUhYuaVIUdNI+8jPbaKH/sc=
Date: Tue, 1 Mar 2011 09:30:17 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reverting NUMA-affine page table allocation
Message-ID: <20110301083017.GD26074@htj.dyndns.org>
References: <20110226143730.GA26864@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110226143730.GA26864@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 03:37:30PM +0100, Tejun Heo wrote:
> I'd like to revert NUMA-affine page table allocation for now and come
> back to it in the next devel cycle.  Thanks to the memblock top-down
> change, the RED-PEN condition (page table ending up in DMA memory)
> doesn't exist with or without NUMA affine allocation and the only
> downside of reverting would be page tables allocated in foreign nodes
> on machines which don't support 1GiB mapping.
> 
> What do you think?

If there's no objection, I'll revert it later today and ask Ingo to
pull it.

Thanks.

-- 
tejun
