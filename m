Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2BUVLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:11:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45865 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab2BUVLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:11:19 -0500
Message-ID: <4F440857.6010907@zytor.com>
Date: Tue, 21 Feb 2012 13:10:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
References: <cover.1329851692.git.jbaron@redhat.com>  <4F43F9F0.4000605@zytor.com> <20120221202019.GB2381@redhat.com> <1329856745.25686.72.camel@gandalf.stny.rr.com>
In-Reply-To: <1329856745.25686.72.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 12:39 PM, Steven Rostedt wrote:
> On Tue, 2012-02-21 at 15:20 -0500, Jason Baron wrote:
> 
>> I'm not really too hung up on the naming, but I did think that
>> very_[un]likely were an interesting possibility.
> 
> The problem comes from what Peter said. They are too similar to
> "likely()" and "unlikely()", and can become confusing.
> 
> Maybe "static_likely()" and "static_unlikely()" as the word "static" can
> imply something strange about these. Or perhaps a "const_likely()"?
> 
> Maybe "dynamic_branch_true()" and "dynamic_branch_false()". This may be
> the most descriptive.
> 

I thought about this some more, and the very_[un]likely() naming is even
worse than I originally thought: the jump label stuff isn't about the
bias level, but rather if a static decision (on the order or once per
boot) can be made to go one way or the other.

	-hpa

