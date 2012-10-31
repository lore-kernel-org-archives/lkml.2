Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045Ab2JaAll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:41:41 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47308 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064Ab2JaAlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:41:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@samsung.com
Cc: Nishanth Menon <nm@ti.com>, linux-pm <linux-pm@vger.kernel.org>,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [for-next PATCH V2] PM / devfreq: Add sysfs node to expose available frequencies
Date: Wed, 31 Oct 2012 01:45:40 +0100
Message-ID: <2118787.BMsTdGrSod@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <16123783.160701351232196244.JavaMail.weblogic@epv6ml08>
References: <16123783.160701351232196244.JavaMail.weblogic@epv6ml08>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 26, 2012 06:16:36 AM MyungJoo Ham wrote:
> > devfreq governors such as ondemand are controlled by a min and
> > max frequency, while governors like userspace governor allow us
> > to set a specific frequency.
> > However, for the same specific device, depending on the SoC, the
> > available frequencies can vary.
> > 
> > So expose the available frequencies as a snapshot over sysfs to
> > allow informed decisions.
> > 
> > This was inspired by cpufreq framework's equivalent for similar
> > usage sysfs node: scaling_available_frequencies.
> > 
> > Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> > Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: Kevin Hilman <khilman@ti.com>
> > Cc: linux-pm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > 
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Are you going to handle this patch?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
