Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1DZTIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:08:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1DZTIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:08:04 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=xiwGX1Xr2kgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=kw_iyntxYLnKvsw6xCoA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 07/11] kbuild/recordmcount: Add RECORDMCOUNT_WARN
 to warn about mcount callers
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org
In-Reply-To: <4DB09629.7080008@suse.cz>
References: <20110421022825.535486725@goodmis.org>
	 <20110421023738.714956282@goodmis.org>  <4DB09629.7080008@suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Apr 2011 15:08:02 -0400
Message-ID: <1303844882.18763.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 22:40 +0200, Michal Marek wrote:
> On 21.4.2011 04:28, Steven Rostedt wrote:
> > +ifeq ("$(origin RECORDMCOUNT_WARN)", "command line")
> > +  RECORDMCOUNT_FLAGS = -w
> > +endif
> 
> RECORDMCOUNT_WARN is IMO unlikely to be used with some other meaning in
> the environment, so I think you can drop the origin check. Nevertheless

You haven't seen my environment variables ;)

> 
> Acked-by: Michal Marek <mmarek@suse.cz>

 Thanks!

-- Steve


