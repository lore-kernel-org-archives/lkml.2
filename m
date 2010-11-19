Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0KSQJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:09:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39902 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0KSQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:09:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s7H87/A33l3OpxBjcJQUHd6Y+c3AedocMMTfvINKDMaX8sjvxlXhZLd3pu0LB2Cdls
         4zDwt6JUbcKamedCEslr7YiMv1StL+FsaN8gGIBNTYvWifMLhqHJT0BnUf1PSmwyRKB8
         +ZVl1FVHGP+VUQjEdmtdqlX6+EsYQHFQBa5dI=
Date: Fri, 19 Nov 2010 21:39:29 +0530
From: Rabin Vincent <rabin@rab.in>
To: linux-arm-kernel@lists.infradead.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/6] ARM: ensure sched_clock() and children are notrace
Message-ID: <20101119160849.GA21870@debian>
References: <1289067954-5080-1-git-send-email-rabin@rab.in>
 <AANLkTik9Wv2p9-=X3roJut3A3KLD1D7UWOB795edjHAX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik9Wv2p9-=X3roJut3A3KLD1D7UWOB795edjHAX@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Nov 6, 2010 at 11:55 PM, Rabin Vincent <rabin@rab.in> wrote:
> > Include sched.h in the files implementing sched_clock() and ensure that
> > any functions called from sched_clock() have the notrace annotation.

On Sat, Nov 13, 2010 at 12:14:51AM +0530, Rabin Vincent wrote:
> CC'd some mach maintainers.  I can split this up if needed,
> since these bits can be applied independently from the rest
> of the patches in the series.

I've split it up anyway, since tegra and nomadik have since fixed it
themselves while reworking their sched_clock() implementations (and
there are probably others who need to do this), and I missed a couple of
functions in omap and u300 in the first patch.
