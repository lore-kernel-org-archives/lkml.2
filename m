Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1KYSLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 13:11:15 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:59849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab1KYSLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 13:11:14 -0500
Subject: Re: [PATCH v2] printk: add console output tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20111125174327.GB23978@somewhere.redhat.com> (sfid-20111125_184407_422143_A5670229)
References: <20111117150040.GB18437@somewhere>
	 <1321543268.3997.40.camel@jlt3.sipsolutions.net>
	 <20111118184401.GA24787@somewhere.redhat.com>
	 <1321641975.10266.73.camel@jlt3.sipsolutions.net>
	 <20111118185449.GB24787@somewhere.redhat.com>
	 <1321642752.10266.75.camel@jlt3.sipsolutions.net>
	 <20111123131622.GA10669@somewhere.redhat.com>
	 <1322140919.5366.17.camel@jlt3.sipsolutions.net>
	 <20111124154519.GB18579@somewhere.redhat.com>
	 <1322161216.5366.52.camel@jlt3.sipsolutions.net>
	 <20111125174327.GB23978@somewhere.redhat.com>
	 (sfid-20111125_184407_422143_A5670229)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Nov 2011 19:11:09 +0100
Message-ID: <1322244669.4123.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-25 at 18:43 +0100, Frederic Weisbecker wrote:

> > > So, in your tracepoint you can safely use "end - start" as a length for your
> > > dynamic array. But the rest of your tracepoint (all the fast assign part)
> > > still needs the masks as you did.
> > 
> > Oh, that's all you were trying to say?
> 
> Yeah I first thought my comment applied to all the mask game in the tracepoint but then
> I started to feel ashamed when I realized it was only on the dynamic array declaration :)

Well it did actually apply to the memcpy length in one of the cases
too :)

johannes

