Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422785Ab2JXV6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:58:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35645 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777Ab2JXV6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:58:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: pdsw-power-team@arm.com, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com, patches@linaro.org
Subject: Re: [PATCH 1/2] cpufreq: return early from __cpufreq_driver_getavg()
Date: Thu, 25 Oct 2012 00:02:17 +0200
Message-ID: <112621141.CGPLIkkgz1@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAKohponGwhC_zmk1Whq56vmZMvjcxXKiSpdvMk4ZU8z0Wa2TBw@mail.gmail.com>
References: <32e5bed743cc6cc4e614291a7080299f5f0d0933.1350677395.git.viresh.kumar@linaro.org> <2737823.2JYE7UmLRN@vostro.rjw.lan> <CAKohponGwhC_zmk1Whq56vmZMvjcxXKiSpdvMk4ZU8z0Wa2TBw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 of October 2012 10:12:07 Viresh Kumar wrote:
> On Oct 20, 2012 3:37 AM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >
> > On Saturday 20 of October 2012 01:42:05 Viresh Kumar wrote:
> > > There is no need to do cpufreq_get_cpu() and cpufreq_put_cpu() for
> drivers that
> > > don't support getavg() routine.
> > >
> > > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> >
> > The patch doesn't seem to follow the changelog or the other way around.
> 
> Sorry if my log isn't clear enough.
> But i could still see it matching the code :)
> 
> I have moved the check for drivers capabilities at the top
> of routine, so that there is no need to call mentioned routines.

OK

Applied to linux-pm.git/linux-next as v3.8 material.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
