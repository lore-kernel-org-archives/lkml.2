Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0IFIez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:34:55 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36915 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab0IFIey convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Mon, 6 Sep 2010 04:34:54 -0400
Message-Id: <4C84C3CA0200007800014730@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 06 Sep 2010 09:34:50 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Michal Marek" <mmarek@suse.cz>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] no need to align .modinfo strings
References: <4C7FB3A80200007800013F22@vpn.id2.novell.com>
 <201009061749.56921.rusty@rustcorp.com.au>
In-Reply-To: <201009061749.56921.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.09.10 at 10:19, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thu, 2 Sep 2010 09:54:40 pm Jan Beulich wrote:
>> Their use is not performance critical, and hence it seems better to
>> save some space.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> The real question is: why is gcc aligning these?  Should it be aligning

A performance consideration for those cases where strings are being
used a lot, I believe.

> any string literals at all?  If so, should we look for other such wastes
> of space?

I think we should, at least I'm keeping an eye open to spot any such.

Jan

