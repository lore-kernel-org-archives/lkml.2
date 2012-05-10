Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033Ab2EJRbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:31:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42904 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455Ab2EJRbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:31:49 -0400
Message-ID: <4FABFB7B.9000001@landley.net>
Date: Thu, 10 May 2012 12:31:39 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        luto@mit.edu, suresh.b.siddha@intel.com, avi@redhat.com,
        johnstul@us.ibm.com, arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/5] [x86]: Improve secondary CPU bring-up process robustness
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com> <1336555184.2527.6.camel@twins> <20120509131258.GA24979@gmail.com>
In-Reply-To: <20120509131258.GA24979@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 08:12 AM, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
>> I'm not quite sure how far along he is, but it would be 
>> awesome if you could help him out somehow.
> 
> bits of Thomas's rework are in latest -tip, the tip:smp/hotplug 
> branch, also merged into tip:master and soon to linux-next.

Um, I missed a curve here: I know what linux-next is, and I know what
staging is (although I'm a bit confused about how those two relate), but
what's tip?  (Do you mean linux's tree?)

I checked applying-patches.txt and HOWTO in case I missed something, and
both are are hideously stale.  (For one thing, both still say 2.6
everywhere.  I guess this is my problem now, I'll try a fixup pass this
weekend.)

In the meantime: what do you mean by tip?

> Thanks,
> 
> 	Ingo
> 

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
