Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab1EENOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 09:14:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56019 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1EENOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 09:14:08 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=wom5GMh1gUkA:10 a=xOt2o2bgqF0A:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=cm27Pg_UAAAA:8 a=hCKJs3DLo4rC--A3YiAA:9 a=CjuIK1q_8ugA:10 a=zv9_9hqRWm8A:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Thu, 5 May 2011 08:14:06 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Will Drewry <wad@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Paris <eparis@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
Message-ID: <20110505131406.GA24235@mail.hallyn.com>
References: <20110429131845.GA1768@nowhere>
 <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
 <20110503012857.GA8399@nowhere>
 <BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
 <BANLkTimPFHwJfqXHShnOt7mBp84NQQNWDw@mail.gmail.com>
 <20110504175229.GB1804@nowhere>
 <1304533382.25414.2447.camel@gandalf.stny.rr.com>
 <20110504183052.GD1804@nowhere>
 <1304534785.25414.2452.camel@gandalf.stny.rr.com>
 <BANLkTin2ZS8DCLGZXxV7EN+S-aNRK=B8Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin2ZS8DCLGZXxV7EN+S-aNRK=B8Sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Will Drewry (wad@chromium.org):
> In particular, if the userspace code wants to stage some filters and
> apply them all at once, when ready, I'm not sure that it makes sense
> to me to put that complexity in the kernel itself.  For instance,

Hi Will,

just one note - in my original comment I wasn't actually suggesting
disabling setting of filters through a writeable file - I was only
suggesting restricting writing to one's own filters file.

All the better if it is possible to get a nice prctl-only
interface, but if it ends up limiting rule expressiveness (or taking
years to define an interface) then perhaps we should stick with
prctl for setting seccomp mode, and a more expressive file interface
for defining filters.

-serge
