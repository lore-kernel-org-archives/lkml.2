Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab1D1Rng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 13:43:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53752 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab1D1Rnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 13:43:35 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=wom5GMh1gUkA:10 a=xOt2o2bgqF0A:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=8CxImXbXt96Q8P5vN1QA:9 a=CjuIK1q_8ugA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Thu, 28 Apr 2011 12:43:34 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        jmorris@namei.org, rostedt@goodmis.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
Message-ID: <20110428174334.GB25940@hallyn.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
 <1303960136-14298-4-git-send-email-wad@chromium.org>
 <20110428070636.GC952@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428070636.GC952@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ingo Molnar (mingo@elte.hu):
> I've Cc:-ed Linus and Andrew: are you guys opposed to such flexible, dynamic 
> filters conceptually? I think we should really think hard about the actual ABI 
> as this could easily spread to more applications than Chrome/Chromium.

We want to use it for containers, to try and provide some bit of
mitigation for the fact that they are sharing a kernel with the host.

thanks,
-serge
