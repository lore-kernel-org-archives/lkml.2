Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1BKJw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 04:52:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37969 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab1BKJwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 04:52:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dd0xpMYgFxYUiqUHjBd0G7yJz5XMfLwr5w4aKOWaweN+BncvfM5gZOmMSi4pCqPFSl
         /hE1ZNJ/AX2LksBHcs9OI8EQmKJCrN5m4CsiVPSdOgaTQRNENk+q4fftB4RUixcBzjGW
         GZ9STb8+pimzkwuTr71errMuYYtkaIZrg/lVc=
Date: Fri, 11 Feb 2011 10:52:18 +0100
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the percpu tree with the tip tree
Message-ID: <20110211095218.GQ3770@htj.dyndns.org>
References: <20110211145810.bdea73a3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110211145810.bdea73a3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 02:58:10PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the percpu tree got a conflict in
> arch/x86/kernel/vmlinux.lds.S between commit
> 94d1ac8b55799be10487fff9766cce6d6628462a ("x86: Reduce back the alignment
> of the per-CPU data section") from the tip tree and commit
> 19df0c2fef010e94e90df514aaf4e73f6b80145c ("percpu: align percpu
> readmostly subsection to cacheline") from the percpu tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks.  Looks good to me.

-- 
tejun
