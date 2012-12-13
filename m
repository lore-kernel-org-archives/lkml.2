Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2LMJnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 04:43:23 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:33639 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2LMJnV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Thu, 13 Dec 2012 04:43:21 -0500
Message-Id: <50C9B14602000078000B00C3@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 13 Dec 2012 09:43:18 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Santos" <daniel.santos@pobox.com>,
        "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <david.daney@cavium.com>, <kosaki.motohiro@jp.fujitsu.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when
 the compiler supports it
References: <5093EB1C02000078000A61D7@nat28.tlf.novell.com>
 <20121105142944.7b16e6a4.akpm@linux-foundation.org>
 <877gpz5wi4.fsf@rustcorp.com.au>
 <5098E50402000078000A698C@nat28.tlf.novell.com>
 <87ehk6443a.fsf@rustcorp.com.au>
 <509A245202000078000A6E8F@nat28.tlf.novell.com>
 <87zk2t2dzp.fsf@rustcorp.com.au> <50C9217B.1010801@att.net>
In-Reply-To: <50C9217B.1010801@att.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.12.12 at 01:29, Daniel Santos <danielfsantos@att.net> wrote:
> Wow, it's really easy to miss parallel development on the same issue.  
> Sorry for my late response to this thread.  I started another thread 
> addressing these issues (as well as a few others) back in September 
> (https://lkml.org/lkml/2012/9/28/1136).  I've finally gotten ACKs from 
> maintainers with v6 of the patches (here 
> https://lkml.org/lkml/2012/11/20/621) and I'm just waiting for 3.8-rc1 
> to re-submit them.  I actually submitted these patches back in June as 
> part of a larger patch set, but broke it apart in September (I had way 
> to many changes for one patch set)

Since yours is apparently ready to go in, but doesn't use
_Static_assert, I guess I'll wait for it to appear until I re-work
whatever might be left to actually make use of _Static_assert.

Jan

