Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1C1QGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:06:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33057 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1C1QGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FYW6ifbkJbw5XFXALE0HrV/pnJWPHn5jNxYlx4BMYucfme3PkpOm3gh4uXhH36whuO
         BFzxhESsTsMsYv9kRogMlxp0ZAvJ6n+Mf08Hz7zTz0ZAWnBQhRqebZwnJVrOcPFVwwyh
         ksnzWVEnhSCnYNSO5p4k5o0hCZjnVf1KMCDl0=
Date: Mon, 28 Mar 2011 18:06:32 +0200
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        npiggin@kernel.dk, rientjes@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] percpu: avoid extra NOP in percpu_cmpxchg16b_double
Message-ID: <20110328160632.GD6736@htj.dyndns.org>
References: <1301161507.2979.105.camel@edumazet-laptop>
 <alpine.DEB.2.00.1103261406420.24195@router.home>
 <alpine.DEB.2.00.1103261428200.25375@router.home>
 <alpine.DEB.2.00.1103261440160.25375@router.home>
 <AANLkTinTzKQkRcE2JvP_BpR0YMj82gppAmNo7RqgftCG@mail.gmail.com>
 <alpine.DEB.2.00.1103262028170.1004@router.home>
 <alpine.DEB.2.00.1103262054410.1373@router.home>
 <1301212347.32248.1.camel@edumazet-laptop>
 <1301308335.3182.12.camel@edumazet-laptop>
 <alpine.DEB.2.00.1103280845480.7590@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103280845480.7590@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 08:46:05AM -0500, Christoph Lameter wrote:
> On Mon, 28 Mar 2011, Eric Dumazet wrote:
> 
> > Therefore, NOPX should be :
> >
> > P6_NOP3 on SMP
> > P6_NOP2 on !SMP
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Applied to percpu#fixes-2.6.39.

Thanks.

-- 
tejun
