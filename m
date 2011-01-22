Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1AVB60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:58:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35505 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab1AVB6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:58:25 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=caeoQ5mqpWkA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=Wo-aebrEy7bbeRxhL0oA:9 a=xBTc7TJ18MYySec_IZg3WcN6FiwA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 21 Jan 2011 20:58:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
        Dima Zavin <dmitriyz@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Joe Perches <joe@perches.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
Subject: Re: [PATCH 0/7] Nexus One Support
Message-ID: <20110122015821.GA6249@home.goodmis.org>
References: <20110121094827.41818a55@jbarnes-desktop>
 <20110121095658.1ab623fe@jbarnes-desktop>
 <1295632828.19880.22.camel@m0nster>
 <20110121100441.06a94482@jbarnes-desktop>
 <1295633882.19880.31.camel@m0nster>
 <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
 <1295642995.19880.42.camel@m0nster>
 <AANLkTikVDn+W8t7KSym5tCGZowyYvoLFrk8d0mumiRF-@mail.gmail.com>
 <20110121234930.GK3043@thunk.org>
 <1295654593.22882.9.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295654593.22882.9.camel@m0nster>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 04:03:13PM -0800, Daniel Walker wrote:
> 
> right, but it wasn't a cherrypick which was explain in the thread. So
> there's no wrongs here ..

I'm sorry Daniel, but you are absolutely wrong!

Did you come up with the logic of this code, or did you take someone
else's code and just massage it until it worked?

If you took someone else's code, where are their Signed-off-by's?

Just look at what I did recently with Lai's rt-mutex clean up patch. I
ported it to the PREEMPT_RT (-rt) patch set. That port took me a week to
do. I had to add a bunch of code to make it work. When it was finished,
did I claim author of it? No! I left Lai as the author and simply added:

 [ Ported to the -rt patch set by Steven Rostedt ]

Take a look at the changes.

  Here's the patch I started with:

https://patchwork.kernel.org/patch/477841/

  Here's what I ended with (all my changes)

https://patchwork.kernel.org/patch/470171/

Do a diff of the two. There was a lot of work going into that. But I did
not come up with change to the algorithm that Lai did, so I kept him as
author. I just added my insert in the change log and added my own SoB
(including his).

If I repaint a Picasso, can I call it a Rostedt?

-- Steve

