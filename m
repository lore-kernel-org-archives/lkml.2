Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2FFJTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:19:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39562 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2FFJTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:19:52 -0400
Message-ID: <1338974373.2749.86.camel@twins>
Subject: Re: [RESEND PATCH 1/3] uprobes: Remove redundant
 lock_page/unlock_page
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>
Date: Wed, 06 Jun 2012 11:19:33 +0200
In-Reply-To: <20120606091844.GA421@gmail.com>
References: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com>
	 <1338465518.28384.55.camel@twins>
	 <20120531150756.GC24279@linux.vnet.ibm.com>
	 <1338483372.28384.65.camel@twins>
	 <20120601091950.GF24279@linux.vnet.ibm.com>
	 <20120606091844.GA421@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 11:18 +0200, Ingo Molnar wrote:

> Is this also a bug fix, or can it wait until v3.6?

No bug, just superfluous locking.
