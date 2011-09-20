Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155Ab1ITNef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:34:35 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37907
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781Ab1ITNee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:34:34 -0400
Date: Tue, 20 Sep 2011 09:34:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 0/26]   Uprobes patchset with perf probe
 support
Message-ID: <20110920133401.GA28550@infradead.org>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 05:29:38PM +0530, Srikar Dronamraju wrote:
> - Uses i_mutex instead of uprobes_mutex.

What for exactly?  I'm pretty strict against introducing even more
uses for i_mutex, it's already way to overloaded with different
meanings.

