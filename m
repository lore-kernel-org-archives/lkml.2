Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab1CCGXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:23:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62242 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab1CCGXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:23:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fooUlpjqzGciGm/HlLZgCpfSFmz7tDDX2eahGbHK1k9J5D+NnTgPiHt45BfkQoD05o
         I/n/NKVwbJR2ujv77dpzSKMcuVclQQtbm7T74oYGb+wM3ZI5ZyCXpA88Qdi3ILI/0QHN
         1VIiHNKmGesrWyaV0EmbhG7a0rql71pwJJ7UQ=
Date: Thu, 3 Mar 2011 07:22:59 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, numa, emu: only transform numa_distance if
 SLIT is there
Message-ID: <20110303062259.GI28266@mtj.dyndns.org>
References: <4D6EEDF2.6090201@kernel.org>
 <4D6EEEC0.3040001@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6EEEC0.3040001@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 05:28:32PM -0800, Yinghai Lu wrote:
> 
> during copying should only copy with NEW numa_dist_cnt size.
> need to call numa_alloc_dist() at first,  and it will set default values.
> 
> So we will not need to go over the big matrix without meaning.
> 
> Need to make numa_alloc_distance to return new numa_dist_cnt
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I'm not taking this.  You can't send the same change twice and expect
different result.

-- 
tejun
