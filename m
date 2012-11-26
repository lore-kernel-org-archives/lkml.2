Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2KZKBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:01:20 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:33563 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab2KZKBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:01:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        myungjoo.ham@gmail.com, sachin.kamat@linaro.org
Subject: Re: [PULL REQUEST for Rafael] PM / devfreq: pull request-3 bugfixes
Date: Mon, 26 Nov 2012 11:06 +0100
Message-ID: <1562412.gSBZdyfWN8@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353912082-8550-1-git-send-email-myungjoo.ham@samsung.com>
References: <3622510.QVzP2QoHuh@vostro.rjw.lan> <1353912082-8550-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 26, 2012 03:41:22 PM MyungJoo Ham wrote:
> Dear Rafael,
> 
> sorry for the inconviences; I forgot that I've updated the tag name
> according to the date modified.
> 
> Please use "pull_req_20121122" tag instead of "pull_req_20121121" though
> I've pushed pull_req_20121121 tag again, which points to the same
> commit with pull_req_20121122 tag.
> 
> 
> "remove compiler error" patch in this set should resolve the "build failure"
> message sent by Stephen as well.

It looks like you rebased it on top of linux-next, didn't you?

Please don't do that, linux-next is evolving and the commit hashes in there
are changing over time.

I've merged your previous pull request into my pm-devfreq branch and pushed
it out.  Please rebase your new material on top of my pm-devfreq branch and
resubmit.

Thanks,
Rafael


> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> The following changes since commit f928d1ce87ad5bd2152cb522de75de03be29e18b:
> 
>   Merge branch 'pm-cpufreq-next' into linux-next (2012-11-22 00:23:28 +0100)
> , which is HEAD of Rafael's linux-pm.git linux-next branch on 2012-11-22.
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git tags/pull_req_20121122
> 
> MyungJoo Ham (2):
>       PM / devfreq: remove compiler error when a governor is module
>       PM / devfreq: missing rcu_read_lock() added for find_device_opp()
> 
> Sachin Kamat (2):
>       PM / devfreq: Fix incorrect argument in error message
>       PM / devfreq: Fix return value in devfreq_remove_governor()
> 
>  drivers/devfreq/devfreq.c |   30 ++++++++++++++++++++++--------
>  include/linux/devfreq.h   |    2 +-
>  2 files changed, 23 insertions(+), 9 deletions(-)
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
> 
> iQIcBAEBAgAGBQJQsw0gAAoJEBOhurvWBoCKFzsP/1uIw/V8sF7/Bi6yYEQVxIxF
> nrgH0BtjSMKyyEG+RJU5fz1xxkfzVIhLHeMzzTDHYG/sY7xwb+eeHWE+PFP6elvm
> NSCOqFf/olNM1dDrUsPpGPtn2Fmfl1wyAOXhdH1lHwQYyDyCgWgQtsqIck1UaLo2
> 6vn9GSl/e/DfpVtg1Wdc63ggtAFk8srZKlU3RQk/Nh/GFMTmdxtG6hibjuM88FjT
> hfFETgaZYPfX+rz36XMa/7pMQQHcrl56K8r3Pu1/RhkM8lVCwlB4tV0Y2sBGfHuL
> 2f0mbX+owjR4YuHS1QMI31Io9FB/F5KzVUdEKE73g2yalCa8ygJfMvJgQqbMYKpA
> IfxyoEvIzbH/T6+cMCQ0WaQ9Buf4KSjmmzL8MSiZB9Ny4Jw5ETg8bZjEU7cR7RWz
> i1grMqyfsjySu/N+slyY7SlvKK+58DytR2WvFvz4ba58dsqEjOoL2ovFz+W3KdlE
> 6V8DGpi2bODbejm6pXx5K6x+VqrByMYCrRpSvmSpYG9PUWpUfjFQMMPgH/uTEXR6
> dJ0H8Hv5+xtUa9sHu9A6nVVSlFgukEVN5BjIEySuX+gj5mIywwN2ZXyIp0TeAis6
> SWUBFflIbjW9JuIP1hwdcrdRsgJ/RyoQZ2XqPVZEQKJgV6C+k38ShOO9Q3YAfJHq
> sO3Gz4WUsME2nkswuwgb
> =SPXQ
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
