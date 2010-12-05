Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0LEHrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 02:47:33 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57542 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab0LEHrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 02:47:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=pS9VyE6KyRFkUqS9Gd5HBFe71hDO2eTX+uiGSDLmYsExWLcN92lLGCzcETij7Oz3Pk
         HxhFsq9N/35BxX5yIKRRI7JgzLOMp0m/L+eOtfxDtCmB+CPF0RD988XvUCm9uup0OALB
         qWSNrSSgrs4Y+p2QDowuQj1tNnOwYFPqm6YHY=
MIME-Version: 1.0
In-Reply-To: <AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
References: <1289783580.495.58.camel@maggy.simson.net> <1289811438.2109.474.camel@laptop>
 <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101116130413.GA29368@redhat.com> <1289917109.5169.131.camel@maggy.simson.net>
 <20101116150319.GA3475@redhat.com> <1289922108.5169.185.camel@maggy.simson.net>
 <20101116172804.GA9930@elte.hu> <1290281700.28711.9.camel@maggy.simson.net>
 <AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
 <AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
 <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
 <AANLkTikFXv042qg4uzXF--9_co6-b_UgJF7Jeo2bVA=f@mail.gmail.com> <AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Sat, 4 Dec 2010 23:47:10 -0800
X-Google-Sender-Auth: K27RjdzxJcl6qNvXdKU3l4xt9Q8
Message-ID: <AANLkTiniEUdADMHUE1a9Fs1bGsWn6F6yeJX_NO4L94JK@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
To: Colin Walters <walters@verbum.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 4, 2010 at 3:43 PM, Colin Walters <walters@verbum.org> wrote:
> So if it's a heuristic the OS can get wrong, wouldn't it be a good
> idea to support a way for programs and/or interactive users to
> explicitly specify things?

Consider a multi-user machine. `nice` is an orthogonal concern in that
case. Therefore, fixing nice doesn't address all issues. Also: Most
linux systems are multi-user (root and the physical tty user.)
Further, even a single user wears multiple hats on a single system.
The idea is to infer those hats, and deal with them fairly.

No one is taking nice away from you. Keep using it if you like.

If you want to allow users to explicitly specify group scheduling,
then good news: we already have that feature. You just seem to not be
using it. Much like the other 99.993% of us.

The kernel is supposed to have *sane defaults*. That's what is under
discussion here.

~r.
