Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2BANUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:20:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59451 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2BANUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:20:23 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0ow4NSV8tcgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=5lmDXb4f-sgiy-48x_4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328102419.5882.60.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 01 Feb 2012 08:20:19 -0500
In-Reply-To: <20120201080539.GA11770@elte.hu>
References: <20120128160925.275163704@goodmis.org>
	 <20120130144857.GA22013@elte.hu>
	 <1327936060.22710.165.camel@gandalf.stny.rr.com>
	 <20120131194813.GA12074@elte.hu>
	 <1328072925.5882.57.camel@gandalf.stny.rr.com>
	 <20120201080539.GA11770@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 09:05 +0100, Ingo Molnar wrote:

> It would be better to make this a regular commit, this kind of 
> diagnostics obviously makes sense. That way i could pull in your 
> updated branch for more testing.

Actually, I was planing on doing that ;-) I just didn't have the time to
push it through my normal testing.

I'm also curious if you get a bug with only patches 1,2, and 3. That is,
the current jump label doesn't do any testing. It would be interesting
to know if something is happening with the current jump label code that
we do not expect.

-- Steve


