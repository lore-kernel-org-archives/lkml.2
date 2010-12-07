Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0LGNGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 08:06:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab0LGNGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 08:06:38 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=ol3fQ0Bz-dcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=wUhFi-14Nor4ALSFRqAA:9 a=Wf10mhRBQpx-V_pldLEYu3_FRBoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 02/10] mm: Remove likely() from
 mapping_unevictable()
From: Steven Rostedt <rostedt@goodmis.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20101207070233.GB3307@amd>
References: <20101207015834.196176991@goodmis.org>
	 <20101207021328.569328536@goodmis.org>
	 <1291688533.16223.119.camel@gandalf.stny.rr.com>
	 <20101207070233.GB3307@amd>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Dec 2010 08:06:35 -0500
Message-ID: <1291727195.16223.140.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 18:02 +1100, Nick Piggin wrote:
> On Mon, Dec 06, 2010 at 09:22:13PM -0500, Steven Rostedt wrote:

> I think so. We don't have good guidelines or empirical numbers on this,
> unfortunately, but I think it would be somewhere over 90%, given that it
> tends to add jumps to and from out of line icache in the incorrect case.

OK, so I'll add the removal of the unlikely() in page_mapping in my next
verison.

> 
> Acked-by: Nick Piggin <npiggin@kernel.dk>

Thanks!

-- Steve



