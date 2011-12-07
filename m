Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab1LGRvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:51:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49073 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab1LGRvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:51:18 -0500
Date: Wed, 7 Dec 2011 18:51:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: Perhaps a side effect regarding NMI returns
Message-ID: <20111207175111.GY24062@one.firstfloor.org>
References: <1322539673.17003.45.camel@frodo> <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com> <m2r50qlmgk.fsf@firstfloor.org> <1322598920.17003.71.camel@frodo> <CA+55aFzgM55hXTs4griX5e9=v_O+=ue+7Rj0PTD=M7hFYpyULQ@mail.gmail.com> <1323275800.30977.101.camel@frodo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323275800.30977.101.camel@frodo>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've tested this patch quite a bit with 'perf top -C 1000' and it holds
> up well. Could you give me your Signed-off-by so I can include it into
> my patch queue?

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
