Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab1FJPGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:06:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37641 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab1FJPGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:06:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tD0MbiD40Gb9VRJ90xtiwc0+QZdfiYpW5j6mHGHIBJhGl/uHCYsVvVk3pgBw25bWDt
         wrNEpzA+NkB1w8YfJO9WYEW5sJgiQXQvAw7LvocbXwy9mLs/K6ww6E8szr8h6IuX4HOn
         lw9PVv50tXn90kyrU2lZ+O8uAvpzGPMlZdGPU=
MIME-Version: 1.0
In-Reply-To: <BANLkTinZGuOE3G5Ro0=LB9Y8wcHVgk-3ug@mail.gmail.com>
References: <20110609214241.GA4849@sepie.suse.cz>
	<BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>
	<BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com>
	<BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>
	<BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com>
	<BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>
	<BANLkTi=wQaUSagZjptGnvUHNpJeMm0C6yw@mail.gmail.com>
	<BANLkTinZGuOE3G5Ro0=LB9Y8wcHVgk-3ug@mail.gmail.com>
Date: Fri, 10 Jun 2011 16:06:01 +0100
X-Google-Sender-Auth: VVYd6eZTPEXip-Pl_4kDQ3xXBeY
Message-ID: <BANLkTikb0=CvTbN_njhq7JyJwOigEa0eLA@mail.gmail.com>
Subject: Re: [GIT] kbuild fixes for 3.0
From: Andy Whitcroft <apw@canonical.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 6:53 AM, Ray Lee <ray-lk@madrabbit.org> wrote:
> On Thu, Jun 9, 2011 at 10:16 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> Beside that, no matter what, you are about to break
>> `/usr/sbin/sensors-detect' (from my Fedora 14), which rely on a 3
>> digits version number:
>
> Is there really any compelling technical reason to _not_ have Linus
> release the kernels with a superfluous .0 on the end, with the
> understanding that the -stable team gets to increment it for their
> future releases? It'd make every kernel.org release exactly three
> dotted decimals from here on out, which certainly simplifies things.
>
> It seems like we're just borrowing trouble here by trying to drop it
> down to two numbers.
>
> (Not, mind you, that I give a damn at all one way or the other, but it
> feels like you all are going to be spending a lot of time tripping
> over poor assumptions in userspace rather than doing actual work.)

As an experiment I have uploaded a 3.0 reporting kernel into Ubuntu
Oneiric.  So far we have had issues with:

 - depmod -- (as above)
 - procps (ps/top) -- reporting errors on startup
 - glibc version checks are preventing upgrade of that package

I am sure there will be others, but the last one above has me cornered
at the moment.  Cirtainly we can fix all of these but we are not going
to make it easy for people with un-upgraded userspace if my experience
is anything to go by.

-apw
