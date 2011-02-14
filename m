Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1BNTTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:19:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1BNTTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:19:03 -0500
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <20110214185400.GB3449@redhat.com>
References: <1297460297.5226.99.camel@laptop>
	 <1297536465.5226.108.camel@laptop> <20110214155113.GA2840@redhat.com>
	 <1297699024.2401.12.camel@twins> <20110214160437.GB2840@redhat.com>
	 <BLU0-SMTP4069A1A89F06CDFF9B28F896D00@phx.gbl>
	 <1297700754.5226.110.camel@laptop> <20110214162947.GA3449@redhat.com>
	 <1297701438.5226.113.camel@laptop>
	 <BLU0-SMTP64371A838030ED92A7CCB696D00@phx.gbl>
	 <20110214185400.GB3449@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 20:20:09 +0100
Message-ID: <1297711209.5226.248.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 13:54 -0500, Jason Baron wrote:

> I don't need an atomic_read() in the disabled case for dynamic debug,
> and I would be ok, #ifdef CONFIG_JUMP_LABEL, in dynamic_debug.h. Its not
> the prettiest solution. But I can certainly live with it for now, so
> that we can sort out the atomic_read() issue independently.
> 
> Peter, Mathieu, are you guys ok with this?

Yeah, lets see where that gets us.

