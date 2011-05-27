Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1E0Fo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:44:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49902 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1E0Fo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=OTaeYNyl0hI0ZQMIykBoe7lv4Wq8BLp0hPW6nrB+nQyUjCJjDGSeAff0mPVVZ5Wa/F
         1243f0Cs42tqpQ3fuBN3S7Y55q9Rokw53WrBc6NEEXQzRQEaFvO7YYPRscqL6QBiBRr4
         oOzxMgR/JN1UH7hL7DxtfgXaMa9GGfrokIzeE=
MIME-Version: 1.0
In-Reply-To: <4DDE81F4.8060800@panasas.com>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
	<20110523192056.GC23629@elte.hu>
	<BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
	<BANLkTinbrtzY66p+1NALP8BDfjXLx=Qp-A@mail.gmail.com>
	<4DDD0E5F.5080105@panasas.com>
	<BANLkTi=FAwzW+qR+Cbwmor90pgbgzfuw-g@mail.gmail.com>
	<4DDE81F4.8060800@panasas.com>
Date: Thu, 26 May 2011 22:44:24 -0700
Message-ID: <BANLkTinj1M_VSuvw1Sct8a6TLkUrEP_4uQ@mail.gmail.com>
Subject: Re: (Short?) merge window reminder
From: Keith Curtis <keithcu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many interesting ideas on version numbering schemes. I like 2.11.X
because it maps to years easily in people's mind, but I look forward
to seeing what is chosen. You guys break many of the rules for
software development, so why not going backwards in version numbers
;-)

While you are talking about arbitrary numbers and new goals, I want to
offer that you could consider a push towards zero bugs. In general, as
long as your reliability monotonically increases (no regressions) that
is an acceptable minimum approach because it means that you will never
have a customer go from being happy to unhappy.

However, it is common in companies to make an effort to get towards
zero bugs. Zero bugs is impossible, and that is a philosophical
discussion. If you look through your current list of bugs, nearly
every one looks scary to me and important to someone. You currently
have 2,800 active bugs (http://bit.ly/LinuxBugs) The last time I
looked, I found the median age was 10 months. In general, bugs should
be fixed in the next release and so therefore 3 months.

Zero bug bounces is hard for the others because they don't have
sufficient resources. However, I believe you easily do. I can't say
that anything magical technically will happen if you work on your bugs
faster, but I can say that people I respect as much as you taught me
this. My salary was based on my ability to promptly respond to my
bugs, and zero was everyone's goal. Hitting zero, even for a minute,
could be a newsworthy event, as another way Linux is better than the
others. It also shows leadership to user mode. I sometimes get the
feeling that many in the FOSS community look at bugs as something they
could work on when they get bored of adding new features, instead of:
"Holy poop, there is someone unhappy out there."

Warm regards,

-Keith
http://keithcu.com/
