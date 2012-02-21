Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2BUUjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:39:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab2BUUjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:39:07 -0500
X-Authority-Analysis: v=2.0 cv=Vp2h8pKn c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=_aPKG9hbZygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=STz4tmehYUBYlxcU_wsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329856745.25686.72.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Feb 2012 15:39:05 -0500
In-Reply-To: <20120221202019.GB2381@redhat.com>
References: <cover.1329851692.git.jbaron@redhat.com>
	 <4F43F9F0.4000605@zytor.com> <20120221202019.GB2381@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 15:20 -0500, Jason Baron wrote:

> I'm not really too hung up on the naming, but I did think that
> very_[un]likely were an interesting possibility.

The problem comes from what Peter said. They are too similar to
"likely()" and "unlikely()", and can become confusing.

Maybe "static_likely()" and "static_unlikely()" as the word "static" can
imply something strange about these. Or perhaps a "const_likely()"?

Maybe "dynamic_branch_true()" and "dynamic_branch_false()". This may be
the most descriptive.

-- Steve



