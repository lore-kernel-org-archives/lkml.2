Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab1EZQLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:11:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49107 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066Ab1EZQLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qfi0pQ6LHdZ3me2/SBfUOOF4lnCA3Jebs5qsDvUObJYgvqxywl4U2XDQmBDOuf2298
         8BEIuORCXMW0AqxSLufka4AtZ4dAN0A0jCJTNFQhjUjPEiDsoJ5IGkdURd+Jvfe2+M0N
         twdtvCt2ZRgXN5e37nSqgtU13HfWcZA0Ufcgk=
Date: Thu, 26 May 2011 19:11:04 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched_rt: RCU-protect for_each_domain() within
 find_lowest_rq()
Message-ID: <20110526161104.GB5716@swordfish.minsk.epam.com>
References: <20110526160137.GA5716@swordfish.minsk.epam.com>
 <1306426071.2497.82.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306426071.2497.82.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (05/26/11 18:07), Peter Zijlstra wrote:
> On Thu, 2011-05-26 at 19:01 +0300, Sergey Senozhatsky wrote:
> > Protect for_each_domain() within find_lowest_rq() with RCU read-side critical 
> > section, suppressing suspicious rcu_dereference_check():
> 
> I just found:
> http://lkml.kernel.org/r/1303469634-11678-1-git-send-email-dfeng@redhat.com in my inbox and queued that.
> 

Great, thanks.

	Sergey
