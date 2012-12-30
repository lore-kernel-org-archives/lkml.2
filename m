Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2L3GSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 01:18:39 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51986 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2L3GSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 01:18:38 -0500
Date: Sat, 29 Dec 2012 22:18:43 -0800
From: Olof Johansson <olof@lixom.net>
To: myungjoo.ham@gmail.com
Cc: Abhilash Kesavan <a.kesavan@samsung.com>, kyungmin.park@samsung.com,
        rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kgene.kim@samsung.com, jhbird.choi@samsung.com
Subject: Re: [PATCH RFC] PM/Devfreq: Add Exynos5-bus devfreq driver for
 Exynos5250.
Message-ID: <20121230061843.GB21331@quad.lixom.net>
References: <1354264973-11214-1-git-send-email-a.kesavan@samsung.com>
 <CAJ0PZbTTDdAXJ378R7CDO2=spx7WF_RpztG5ch7iFZWx-v3N2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0PZbTTDdAXJ378R7CDO2=spx7WF_RpztG5ch7iFZWx-v3N2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 11, 2012 at 10:20:51AM +0900, MyungJoo Ham wrote:
> On Fri, Nov 30, 2012 at 5:42 PM, Abhilash Kesavan <a.kesavan@samsung.com> wrote:
> >  drivers/devfreq/Kconfig        |   10 +
> >  drivers/devfreq/Makefile       |    1 +
> >  drivers/devfreq/exynos5_bus.c  |  595 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/devfreq/exynos5_ppmu.c |  395 ++++++++++++++++++++++++++
> >  drivers/devfreq/exynos5_ppmu.h |   26 ++
> >  drivers/devfreq/exynos_ppmu.c  |   56 ++++
> >  drivers/devfreq/exynos_ppmu.h  |   79 ++++++
> >  7 files changed, 1162 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/devfreq/exynos5_bus.c
> >  create mode 100644 drivers/devfreq/exynos5_ppmu.c
> >  create mode 100644 drivers/devfreq/exynos5_ppmu.h
> >  create mode 100644 drivers/devfreq/exynos_ppmu.c
> >  create mode 100644 drivers/devfreq/exynos_ppmu.h
> 
> I understand that Exynos PPMU drivers seem not to be used (at least in
> mainline Linux) widely and it'd be convinent for a bus driver to have
> ppmu driver located in the same source directory.
> 
> However, I don't feel very comfortable to have ppmu drivers explicitly
> landing in devfreq directory. Would it be possible to place them
> somewhere else? (in drivers/misc, arch/arm/mach-exynos, or somewhere
> appropriate?) If PPMU drivers really have nowhere to relocate, they
> may be located along with its sole user (exynos5_bus.c) anyway.

Why can't they be in drivers/busfreq? Create a subdirectory for
platform-specific subdrivers if needed, but they definitiely do NOT
belong in drivers/misc, and there seems to be little reason to have them
in arch/arm.



-Olof
