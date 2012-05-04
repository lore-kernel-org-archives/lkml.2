Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab2EDV3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:29:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab2EDV33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:29:29 -0400
Date: Fri, 4 May 2012 14:29:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Shi <alex.shi@intel.com>
Cc: linux-kernel@vger.kernel.org, cl@gentwo.org, eric.dumazet@gmail.com,
        tglx@linutronix.de, avi@redhat.com, davem@davemloft.net,
        kaber@trash.net, a.p.zijlstra@chello.nl, ying.huang@intel.com,
        konrad.wilk@oracle.com, hpa@zytor.com, jeremy@goop.org
Subject: Re: [PATH v2 0/5] Code clean up for percpu_xxx serial functions
Message-Id: <20120504142926.a930ba90.akpm@linux-foundation.org>
In-Reply-To: <1326470018-22342-1-git-send-email-alex.shi@intel.com>
References: <1326470018-22342-1-git-send-email-alex.shi@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012 23:53:33 +0800
Alex Shi <alex.shi@intel.com> wrote:

> I am sorry for spelling mistaken on konrad's email address, so resend
> for correct this. Please reply this resend email. 
> 
> ---------------
> Thanks for TJ's suggestion, I split the serial patch smaller for
> potential bisection convenience.
> 
> Compare to v1 patch, this v2 patches has separate function replace
> patches and final dead code clean up patch. 
> 
> The net, xen and x86 part code are independent. 
> 
> After each part was accepted in kernel, the final(5th) clean up code
> do the real clean up in next merge window. I will refresh the patch
> at that time. 
> 
> Any further comments are appreciated!
> 

I'm still sitting on these patches.  The review was a bit inconclusive
and confusing and everyone will have forgotten all about everything.  I
think I'll drop them and ask for a resend, please.

Be sure to update the changelogs so that they address everything which
was discussed last time - so we don't end up covering the same ground. 
Please also Cc everyone who was involved in the discussion last time.


