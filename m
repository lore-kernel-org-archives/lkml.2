Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab1CBTxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:53:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45065
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756281Ab1CBTxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:53:35 -0500
Date: Wed, 02 Mar 2011 11:54:11 -0800 (PST)
Message-Id: <20110302.115411.183067873.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: oleg@redhat.com, akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, pageexec@freemail.hu,
        solar@openwall.com, eteo@redhat.com, spender@grsecurity.net,
        roland@redhat.com, miltonm@bga.com
Subject: Re: [PATCH v3 0/4] exec: unify native/compat code
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=e7n63cCTUe1T+C0d6Ni1VVBFZZ6y_rj-2RQwu@mail.gmail.com>
References: <AANLkTinzQmprg+XHKjTj7bA+jFf_N4hta3_09M+SEfRt@mail.gmail.com>
	<20110302.114018.104077586.davem@davemloft.net>
	<AANLkTi=e7n63cCTUe1T+C0d6Ni1VVBFZZ6y_rj-2RQwu@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Mar 2011 11:48:03 -0800

> Well, the thing is, on architectures that _can_ pass by value, it
> avoids one indirection.
> 
> And if you do pass it on stack, then the code generated will be the
> same as if we passed a pointer. So sparc may not be able to take
> advantage of the optimization, but I don't think the code generation
> would be worse.

That's a good point, the situation here is different than the page table
one.
