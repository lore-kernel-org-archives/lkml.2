Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab0FULHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:07:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab0FULHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:07:44 -0400
Message-ID: <4C1F47EF.2060509@redhat.com>
Date: Mon, 21 Jun 2010 19:07:27 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Dan Carpenter <error27@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H.PeterA" <"nvin hpa"@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [patch] x86, pat: freeing invalid memtype messages
References: <20100617134559.GA29824@bicker> <20100617161728.GA2741@joi.lan>	 <4C1B1691.6020809@redhat.com> <20100618175726.GA2785@joi.lan>	 <4C1F455E.6050502@redhat.com> <1277118155.1875.508.camel@laptop>
In-Reply-To: <1277118155.1875.508.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2010 07:02 PM, Peter Zijlstra wrote:
> On Mon, 2010-06-21 at 18:56 +0800, Xiaotian Feng wrote:
>
>> I guess there might be something wrong between the augmented rbtree insert/remove ..
>
> The easiest thing is to revert that change and try again, the next step
> would be to print the full RB tree on each modification and look where
> it goes wrong.
>
> That said, I did print my fair share of (augmented) RB trees while
> playing with scheduler patches and I can't remember it ever having
> messed up like that.
He's using 2.6.35-rc2+, without your "rbtree: Undo augmented trees 
performance damage" patch ;-)

