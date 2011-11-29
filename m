Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1K2VWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:22:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53843 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab1K2VWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:22:11 -0500
X-Authority-Analysis: v=2.0 cv=Xd0LPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=x9VNfy9Nl58A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=18kCY76J9N-rlaogxnQA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Perhaps a side effect regarding NMI returns
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Turner <pjt@google.com>
In-Reply-To: <CA+55aFw8cAeixca_LWJN7C5W52i7uC-WN-CdND37hvCYHVdRVw@mail.gmail.com>
References: <1322539673.17003.45.camel@frodo>
	 <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
	 <m2r50qlmgk.fsf@firstfloor.org>
	 <CA+55aFxyBYFbx=AGgJ35Dx+U8KVPktesHetYnQrYpt1QGKTrbQ@mail.gmail.com>
	 <20111129203111.GQ24062@one.firstfloor.org>
	 <CA+55aFxUFkHGXk_eEN1GYsZWe5_G9uoCP6DkL6bw9+wWP2_fcw@mail.gmail.com>
	 <1322600301.17003.84.camel@frodo>
	 <CA+55aFw8cAeixca_LWJN7C5W52i7uC-WN-CdND37hvCYHVdRVw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 16:22:09 -0500
Message-ID: <1322601729.17003.86.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 13:05 -0800, Linus Torvalds wrote:

> Too late for 3.2 obviously, since I don't think anybody has actually
> reported the "delayed NMI's" as a real problem - so even if it's a
> bug, it's not a bug we should try to fix at this stage.

Oh no, I had no plans to get this into 3.2. I'm optimistic just to get
this into 3.3.

Thanks!

-- Steve


