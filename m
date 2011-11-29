Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab1K2UbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:31:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47825 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1K2UbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:31:13 -0500
Date: Tue, 29 Nov 2011 21:31:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Turner <pjt@google.com>
Subject: Re: Perhaps a side effect regarding NMI returns
Message-ID: <20111129203111.GQ24062@one.firstfloor.org>
References: <1322539673.17003.45.camel@frodo> <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com> <m2r50qlmgk.fsf@firstfloor.org> <CA+55aFxyBYFbx=AGgJ35Dx+U8KVPktesHetYnQrYpt1QGKTrbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxyBYFbx=AGgJ35Dx+U8KVPktesHetYnQrYpt1QGKTrbQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 12:12:44PM -0800, Linus Torvalds wrote:
> The problem is that NMI's are blocked!
> 
> We're potentially switching to another process, there is no guarantee
> there will be an "iret" *anywhere* in any patch for a long time. So
> any subsequent NMI's will not be able to come in.

True. That's a bug that needs to be fixed.

As a simple fix your proposal of forcing IRET sounds good.

-Andi
