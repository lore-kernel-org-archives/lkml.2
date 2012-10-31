Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935109Ab2JaJJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:09:50 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48090 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab2JaJJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:09:44 -0400
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
Date: Wed, 31 Oct 2012 10:13:48 +0100
Message-ID: <2871085.TQE48VIldN@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <29176137.554861351650430580.JavaMail.weblogic@epv6ml03>
References: <29176137.554861351650430580.JavaMail.weblogic@epv6ml03>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 31, 2012 02:27:10 AM 함명주 wrote:
> > On Tuesday, October 30, 2012 08:09:09 AM MyungJoo Ham wrote:
> []
> > > 
> > > Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > > 
> > > Applying to git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git for-rafael, which is based on rafael's linux-pm.git / linux-next.
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/mzx/devfreq.git;a=shortlog;h=refs/heads/for-rafael
> > > 
> > > I'll apply your "Add sysfs node ..." patch after refactoring with Jonghwa's (devfreq trans_stat) as the two patches use the same data (list of available freqs).
> > 
> > May I assume that you'll handle all of the subsequent devfreq patches too?
> > 
> > Rafael
> 
> Yes, you may. I'll apply the patches (currently at http://git.kernel.org/?p=linux/kernel/git/mzx/devfreq.git;a=shortlog;h=refs/heads/for-rafael ) and send pull requests to you or Linus.
> 
> Anyway, do you want me to keep sending pull requests to you as you've told
> last time?

Yes, please.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
