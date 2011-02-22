Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1BVXM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:12:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43412 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1BVXM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:12:56 -0500
Date: Wed, 23 Feb 2011 00:12:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jason Baron <jbaron@redhat.com>
Cc: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jump label: introduce static_branch() interface
Message-ID: <20110222231252.GE5818@one.firstfloor.org>
References: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Define:
> 
>         struct jump_label_key jump_key;
> 
> Can be used as:
> 
>         if (static_branch(&jump_key))
>                 do unlikely code

Looks much nicer than before indeed.  Thanks for  this cleanup.

-Andi
