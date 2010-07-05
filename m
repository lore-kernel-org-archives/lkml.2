Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0GEJhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 05:37:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab0GEJhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:37:36 -0400
Message-ID: <4C31A7A0.1020800@redhat.com>
Date: Mon, 05 Jul 2010 17:36:32 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Ali Gholami Rudi <ali@rudi.ir>
CC: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [regression] commit 6a4f3b52 causes invalid memtype
References: <20100507075128@tarekhel>	<4C319D61.5090002@redhat.com> <20100507092842@tarekhel>
In-Reply-To: <20100507092842@tarekhel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 05:28 PM, Ali Gholami Rudi wrote:
> Xiaotian Feng<dfeng@redhat.com>  wrote:
>> Could you please try following commit in -tip tree?
>>
>> commit 2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
>> Author: Peter Zijlstra<peterz@infradead.org>
>> Date:   Sat May 29 15:31:43 2010 +0200
>>
>>       rbtree: Undo augmented trees performance damage
>
> Where can I get it?  I couldn't find it either in
> Linus' or x86 repo tip.
http://git.kernel.org/tip/2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
>
> Thanks,
> Ali
>

