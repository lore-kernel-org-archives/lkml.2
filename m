Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab2J3Xj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 19:39:28 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab2J3XjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 19:39:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@samsung.com
Cc: Randy Dunlap <rdunlap@xenotime.net>, Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?7J207KKF7ZmU?= <jonghwa3.lee@samsung.com>
Subject: Re: [linux-next PATCH] PM / devfreq: documentation cleanups for devfreq header
Date: Wed, 31 Oct 2012 00:43:28 +0100
Message-ID: <16298248.vOPLeU1Xi9@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <31002982.486491351584547433.JavaMail.weblogic@epv6ml03>
References: <31002982.486491351584547433.JavaMail.weblogic@epv6ml03>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 30, 2012 08:09:09 AM MyungJoo Ham wrote:
> > On 10/29/2012 06:02 AM, Nishanth Menon wrote:
> > 
> > > struct parameters need to have ':' in documentation for
> > > scripts/kernel-doc to parse appropriately.
> > > 
> > > Fix the errors reported by:
> > > ./scripts/kernel-doc include/linux/devfreq.h >/dev/null
> > > 
> > > Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> > > Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > > Cc: Kevin Hilman <khilman@ti.com>
> > > Cc: linux-pm@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > 
> > > Signed-off-by: Nishanth Menon <nm@ti.com>
> > 
> > 
> > Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Thanks.
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> 
> Applying to git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git for-rafael, which is based on rafael's linux-pm.git / linux-next.
> 
> http://git.kernel.org/?p=linux/kernel/git/mzx/devfreq.git;a=shortlog;h=refs/heads/for-rafael
> 
> I'll apply your "Add sysfs node ..." patch after refactoring with Jonghwa's (devfreq trans_stat) as the two patches use the same data (list of available freqs).

May I assume that you'll handle all of the subsequent devfreq patches too?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
