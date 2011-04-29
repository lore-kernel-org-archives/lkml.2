Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab1D2Ojz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:39:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60200 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab1D2Ojx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:39:53 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=575XYcmA88AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ioKl8Mfd0ZsFKEeg6H8A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 00/18] RAS daemon: Easter Eggs Edition
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
In-Reply-To: <20110429140844.GB1768@nowhere>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
	 <20110429140844.GB1768@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Apr 2011 10:39:49 -0400
Message-ID: <1304087990.18763.251.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 16:08 +0200, Frederic Weisbecker wrote:
> On Sat, Apr 23, 2011 at 06:28:02PM +0200, Borislav Petkov wrote:

> If you want to accelerate that, I suggest you cut your patchset into smaller
> sets and focus on merging them piece by piece. Few people are going to review
> 18 patches at once. They may plan to scatter their review over days but
> that doesn't scale well, and it naturally reduces the number of reviewers.

True, I tend to ignore almost anything more than 8 patches. Or I'll
start reviewing them, get 5 patches into it and then have to work on
other things, and never finish the rest.

-- Steve


