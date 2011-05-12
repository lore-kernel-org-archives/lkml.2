Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab1ELW3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:29:50 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:53751 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab1ELW3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:29:48 -0400
Subject: Re: [PATCH 3/3] comm: ext4: Protect task->comm access by using %ptc
From: John Stultz <john.stultz@linaro.org>
To: David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1105121513070.9130@chino.kir.corp.google.com>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
	 <1305073386-4810-4-git-send-email-john.stultz@linaro.org>
	 <alpine.DEB.2.00.1105121513070.9130@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 15:29:40 -0700
Message-ID: <1305239380.2680.26.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 15:14 -0700, David Rientjes wrote:
> On Tue, 10 May 2011, John Stultz wrote:
> 
> > Converts ext4 comm access to use the safe printk %ptc accessor.
> > 
> > CC: Ted Ts'o <tytso@mit.edu>
> > CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > CC: David Rientjes <rientjes@google.com>
> > CC: Dave Hansen <dave@linux.vnet.ibm.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: linux-mm@kvack.org
> > Signed-off-by: John Stultz <john.stultz@linaro.org>
> 
> I like how this patch illustrates how easy it is to use the new method for 
> printing a task's command, but it would probably be easier to get the 
> first two patches in the series (those that add the seqlock and then %ptc) 
> merged in mainline and then break out a series of conversions such as this 
> that could go through the individual maintainer's trees.

Agreed. I just wanted to show how it would be used compared to the
earlier approach.

I'll respin the first two patches shortly here. I also need to get the
checkpatch bit done.

Andrew, should these go upstream through you?

thanks
-john


