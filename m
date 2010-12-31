Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0LaLRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 06:17:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57059 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0LaLRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 06:17:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gErPsHj38UVIPG+uBx3i9iSECzzjM9R8TMsOZLepBSVXJfegfH4No52bgFOw2618dM
         i5yb/cAwWuVWkj4tL9ZLgxU4K03Z8Hm388NHF5BAf7U7QAfvOgIe8xbtYVtyXJtIM0R8
         mnFee9VO2FNakhzlJqbBrl8ruyg1x1JiB9h3E=
Date: Fri, 31 Dec 2010 12:17:12 +0100
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the percpu tree with the tip tree
Message-ID: <20101231111712.GF18831@htj.dyndns.org>
References: <20101231135546.73f318bc.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101231135546.73f318bc.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 31, 2010 at 01:55:46PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the percpu tree got a conflict in
> arch/x86/kernel/apic/x2apic_uv_x.c between commit
> d8850ba425d9823d3184bd52f065899dac4689f9 ("x86, UV: Fix the effect of
> extra bits in the hub nodeid register") from the tip tree and commit
> 0a3aee0da4402aa19b66e458038533c896fb80c6 ("x86: Use this_cpu_ops to
> optimize code") from the percpu tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thank you.  Looks good to me.

-- 
tejun
